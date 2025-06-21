resource "aws_s3_bucket" "game_bucket" {
  bucket = var.bucket_name
    force_destroy = true
  tags = {
    Name        = "Game Bucket"
    Environment = var.Environment
  }
}