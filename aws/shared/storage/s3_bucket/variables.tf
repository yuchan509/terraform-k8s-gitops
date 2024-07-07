variable "s3_bucket_name" {
  description = "The Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "AWS S3 Tags"
  type        = map(string)
}

