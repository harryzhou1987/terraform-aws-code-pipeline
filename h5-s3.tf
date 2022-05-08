resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "codepipeline-artifacts-${data.aws_caller_identity.current.account_id}-${random_id.this.hex}"
  force_destroy = true
}