# Random ID
resource "random_id" "this" {
  byte_length = 8
}



# IAM Role _> Policy Attachment _> Policy _> Policy Document
## Code Pipeline Role
resource "aws_iam_role" "terraform_codepipeline_role" {
  name = "terraform_codepipeline_role_${random_id.this.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "terraform_codepipeline_policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*","sns:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "terraform_codepipeline_policy" {
    name = "terraform_codepipeline_policy_${random_id.this.hex}"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.terraform_codepipeline_policies.json
}

resource "aws_iam_role_policy_attachment" "terraform_codepipeline_attachment" {
    policy_arn = aws_iam_policy.terraform_codepipeline_policy.arn
    role = aws_iam_role.terraform_codepipeline_role.id
}







# Code Build Role
resource "aws_iam_role" "terraform_codebuild_role" {
  name = "terraform_codebuild_role_${random_id.this.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "terraform_codebuild_policies" {
    statement{
        sid = ""
        # actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]   
        actions = ["*"]   # Not best practice. Demo Only 
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "terraform_codebuild_policy" {
    name = "terraform_codebuild_policy_${random_id.this.hex}"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.terraform_codebuild_policies.json
}

resource "aws_iam_role_policy_attachment" "terraform_codebuild_attachment1" {
    policy_arn  = aws_iam_policy.terraform_codebuild_policy.arn
    role        = aws_iam_role.terraform_codebuild_role.id
}

resource "aws_iam_role_policy_attachment" "terraform_codebuild_attachment2" {
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    role        = aws_iam_role.terraform_codebuild_role.id
}