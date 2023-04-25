resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.prefix}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4" # only choice
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }


    default_ttl            = 86400    // 24h if no Cache-Control max-age or Expires
    min_ttl                = 3600     // 1h
    max_ttl                = 31536000 // 365 days
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"
  /*
    PriceClass_ALL - All countries
    PriceClass_200 - Exclude Australia/New Zealand & South America
    PriceClass_100 - NA + EU
  */

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags

}