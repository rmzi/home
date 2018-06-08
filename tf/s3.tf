# S3 Bucket configured as a website backend
resource "aws_s3_bucket" "site" {
  bucket = "${var.dns["name"]}"

  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.logs.bucket}"
    target_prefix = "access_logs/"
  }
}

# Site Home
resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.site.bucket}"
  key    = "index.html"
  source = "../www/index.html"
  etag   = "${md5(file("../www/index.html"))}"
  content_type = "text/html"
}

# Logging bucket for website (also logs its own access to self)
resource "aws_s3_bucket" "logs" {
  bucket = "${var.dns["name"]}-logs"
  acl = "log-delivery-write"
  force_destroy = true
}

# resource "aws_s3_bucket_policy" "origin-access" {
#   bucket = "${aws_s3_bucket.site.id}"
#   policy = "${data.aws_iam_policy_document.s3_policy.json}"
# }
#
# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.site.arn}/*"]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
#     }
#   }
#
#   statement {
#     actions   = ["s3:ListBucket"]
#     resources = ["${aws_s3_bucket.site.arn}"]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
#     }
#   }
# }

resource "aws_s3_bucket_policy" "full-s3-access" {
  bucket = "${aws_s3_bucket.site.id}"
  policy = "${data.aws_iam_policy_document.full_s3_access.json}"
}

data "aws_iam_policy_document" "full_s3_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  # statement {
  #   actions   = ["s3:ListBucket"]
  #   resources = ["${aws_s3_bucket.site.arn}"]
  #
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
  #   }
  # }
}
