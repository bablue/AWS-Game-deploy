variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
  default = "game-bucket-bhaskar-dev"
}
variable "Environment" {
  description = "The environment for the S3 bucket."
  type        = string
  default     = "Development"
  
}