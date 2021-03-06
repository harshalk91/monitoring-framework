module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  # insert the 23 required variables here
  name = "monitoring-framework-vpc"
  cidr = "192.168.1.0/24"

  azs                = ["us-east-1a"]
  public_subnets     = ["192.168.1.0/24"]
  enable_nat_gateway = false

  tags = {
    terraform = true
  }
}