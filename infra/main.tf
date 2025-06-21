module "s3" {
  source = "./modules/s3"

  # Pass variables as needed
  bucket_name = var.bucket_name
  Environment = var.Environment
}