output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value       = module.terrahouse_aws.bucket_name
}

output "s3_website_endpoint" {
  value = module.terrahouse_aws.website_endpoint
}

output "cloudfront_url" {
  description = "The cloudfront distribution domain"
  value       = module.terrahouse_aws.cloudfront_url
}