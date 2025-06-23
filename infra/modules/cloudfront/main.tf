resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.s3_bucket_name}-oac"
  description                       = "OAC for S3 static site"
  origin_access_control_origin_type  = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_site" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "s3-static-site"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols   = ["TLSv1.2"]
    # }
    # s3_origin_config {} 
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-static-site"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

output "domain_name" {
  value = aws_cloudfront_distribution.static_site.domain_name
}
