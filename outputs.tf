output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value       = module.home_swos_hosting.bucket_name
}

output "s3_website_endpoint" {
  value = module.home_swos_hosting.website_endpoint
}

output "domain_name" {
  description = "The cloudfront distribution domain"
  value       = module.home_swos_hosting.domain_name
}