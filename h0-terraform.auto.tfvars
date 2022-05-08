# Generic Variables  
aws_credential_profile = "your_own_credential" # configured in ~/.aws/credentials
aws_region = "ap-southeast-2"
team = "tech"
environment = "devops"

# Pipeline Credentials
codestart_connector_credentials = "arn:aws:codestar-connections:ap-southeast-2:072855925634:connection/f09864f5-72dc-4c0f-ace7-6a576c5741d8"
repository_id = "harryzhou1987/terraform-aws-cicd-deployment"
branch_name = "main"

# dockerhub_credentials = "arn:aws:secretsmanager:ap-southeast-2:[accountId]:secret:dockerhub/credential-[code]"

# Approval in Pipeline
approve_comment = "Please review the architecture in Dev Enrionment and Approve this Stage Deployment."
sns_email_endpoint = "harry.zhou@spark.co.nz"