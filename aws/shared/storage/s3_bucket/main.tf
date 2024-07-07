module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = var.enable_versioning
  }

  tags = merge(var.tags, {
    "Name" = "${var.s3_bucket_name}"
  })
}