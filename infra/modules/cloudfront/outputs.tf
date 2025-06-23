output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.static_site.arn
}