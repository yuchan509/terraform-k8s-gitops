variable "table_name" {
    description = "AWS DynamoDB Table Name"
    type = string
}

variable "tags" {
  description = "AWS S3 Tags"
  type        = map(string)
}

