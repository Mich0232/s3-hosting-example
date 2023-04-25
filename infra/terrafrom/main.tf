#################
# Origin Bucket #
#################
resource "aws_s3_bucket" "this" {
  bucket = "${local.prefix}-bucket"

  tags = local.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }
}

data "aws_iam_policy_document" "s3_bucket_public_access" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.s3_bucket_public_access.json
}

##################
# Logging Bucket #
##################
module "logging_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${local.prefix}-logging"
  acl    = "private"

  versioning = {
    enabled = true
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = local.tags
}