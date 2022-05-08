# Terraform Deploy in Dev Environment using CodeBuild in Code Pipeline
resource "aws_codebuild_project" "terraform-dev" {
  name          = "cicd_build_in_dev_${random_id.this.hex}"
  description   = "CICD Deploy in Dev Environment"
  # build_timeout = "5"
  service_role  = aws_iam_role.terraform_codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    # image_pull_credentials_type = "SERVICE_ROLE"  
    # registry_credential {
    #   credential = var.dockerhub_credentials
    #   credential_provider = "SECRETS_MANAGER"
  }
  source {
    type            = "CODEPIPELINE"
    buildspec = "buildspec-dev.yml"
  }
}


# Terraform Deploy in Stage Environment using CodeBuild in Code Pipeline
resource "aws_codebuild_project" "terraform-stage" {
  name          = "cicd_build_in_stage_${random_id.this.hex}"
  description   = "CICD Deploy in Stage Environment"
  service_role  = aws_iam_role.terraform_codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
  }
  source {
    type            = "CODEPIPELINE"
    buildspec = "buildspec-stage.yml"
  }
}



### Code Pipeline
resource "aws_codepipeline" "terraform_codepipeline" {
  depends_on = [
    aws_codebuild_project.terraform-dev,
    aws_codebuild_project.terraform-stage,   
  ]
  name     = "terraform_codepipeline_${random_id.this.hex}"
  role_arn = aws_iam_role.terraform_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestart_connector_credentials
        FullRepositoryId = var.repository_id
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Build-Dev"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      # output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform-dev.name
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = "${resource.aws_sns_topic.approval_sns_topic.arn}"
        CustomData = "${var.approve_comment}"
        # ExternalEntityLink = ""
      }
    }
  }

  stage {
    name = "Build-Stage"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      # output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform-stage.name
      }
    }
  }

}