# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-southeast-2"
}

# Environment
variable "environment" {
  description = "Environment"
  type = string
}

# Team
variable "team" {
  description = "Team"
  type = string
}

# Credential Profile
variable "aws_credential_profile" {
  description = "Your Own AWS credential Profile"
  type = string
}

# Codestart Connector
variable "codestart_connector_credentials" {
  type = string
}

variable "repository_id" {
  type = string
}

variable "branch_name" {
  type = string
}

# Dockerhub Credential
# variable "dockerhub_credentials" {
#   type = string
# }


# Approval Notification
variable "approve_comment" {
  type = string
}

variable "sns_email_endpoint" {
  type = string
}
