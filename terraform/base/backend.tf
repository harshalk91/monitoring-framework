terraform {
  backend "s3" {
    encrypt = true
    bucket = "tfstates-devops"
    key    = "monitoring-framework/base.tf"
    dynamodb_table = "terraform-state-lock-dynamo"
    region = "us-east-1"
  }
}
