module "dynamodb_table" {
  source       = "terraform-aws-modules/dynamodb-table/aws"

  name         = var.table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
  tags = {
    "Name" = "${var.table_name}"
  }
}