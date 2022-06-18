module "dynamo_table" {
  source = "../modules/dynamo-db"
  table_name = var.table_name
}