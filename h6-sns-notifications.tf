resource "random_pet" "this" {
}

# Notifications

## SNS - Topic
resource "aws_sns_topic" "approval_sns_topic" {
  name = "${local.name}-pipeline-notification-${random_pet.this.id}"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "approval_sns_topic_subscription" {
  topic_arn = aws_sns_topic.approval_sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}