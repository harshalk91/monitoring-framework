module "ec2_dynamo" {
  source = "../modules/dynamo-db"
  table_name = "terraform-state-lock-ec2"
}