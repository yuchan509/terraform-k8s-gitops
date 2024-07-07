output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.s3-tfstate.s3_bucket_bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = module.s3-tfstate.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = module.s3-tfstate.s3_bucket_hosted_zone_id
}

output "s3_bucket_lifecycle_configuration_rules" {
  description = "The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string."
  value       = module.s3-tfstate.s3_bucket_lifecycle_configuration_rules
}

output "s3_bucket_policy" {
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = module.s3-tfstate.s3_bucket_policy
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = module.s3-tfstate.s3_bucket_region
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = module.s3-tfstate.s3_bucket_website_endpoint
}

output "s3_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. "
  value       = module.s3-tfstate.s3_bucket_website_domain
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.Locking_dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.Locking_dynamodb_table.dynamodb_table_id
}
