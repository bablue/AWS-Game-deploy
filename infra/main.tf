module "s3" {
  source = "./modules/s3"

  # Pass variables as needed
  bucket_name = var.bucket_name
  Environment = var.Environment
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "cloudfront" {
  source         = "./modules/cloudfront"
  s3_bucket_name = module.s3.bucket_name
  # s3_website_endpoint = module.s3.website_endpoint
  s3_website_endpoint = module.s3.bucket_regional_domain_name
  s3_bucket_domain_name   = module.s3.bucket_regional_domain_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.domain_name
}