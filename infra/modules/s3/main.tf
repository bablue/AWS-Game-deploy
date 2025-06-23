resource "aws_s3_bucket" "game_bucket" {
  bucket = var.bucket_name
    force_destroy = true
  tags = {
    Name        = "Game Bucket"
    Environment = var.Environment
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.game_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
}

resource "aws_s3_bucket_public_access_block" "private_access" {
  bucket = aws_s3_bucket.game_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_cloudfront_oac" {
  bucket = aws_s3_bucket.game_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.game_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.game_bucket.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket.game_bucket.website_endpoint
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.game_bucket.bucket_regional_domain_name
}