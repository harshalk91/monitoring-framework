terraform {
  backend "s3" {
#    encrypt        = true
    bucket         = "tfstates-devops"
    key            = "monitoring-framework/ec2.tf"
#    dynamodb_table = "terraform-state-lock-ec2"
    region         = "us-east-1"
  }
}
