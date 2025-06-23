variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
  default = "game-bucket-bhaskar"
}
variable "Environment" {
  description = "The environment for the S3 bucket."
  type        = string
  default     = "Development"
  
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution for OAC access"
  type        = string
}