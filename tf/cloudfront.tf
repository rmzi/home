# Fetch AWS-issued Cert (OOB)
data "aws_acm_certificate" "site" {
  domain      = "${var.dns["name"]}"
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Allow access to site resources"
}

# cloudfront distribution
resource "aws_cloudfront_distribution" "site" {
  origin {
    domain_name = "${aws_s3_bucket.site.bucket_regional_domain_name}"
    origin_id   = "${var.dns["name"]}-origin"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  aliases             = ["${var.dns["name"]}"]
  price_class         = "PriceClass_100"
  default_root_object = "index.html"

  logging_config {
     include_cookies = false
     bucket          = "${aws_s3_bucket.logs.bucket_domain_name}"
     prefix          = "cdn/"
   }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH",
      "POST",
      "PUT",
    ]

    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.dns["name"]}-origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 1000
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.site.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
