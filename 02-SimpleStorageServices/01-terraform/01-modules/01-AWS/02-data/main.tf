# 1. Enable versioning
resource "aws_s3_bucket" "aws_general_purpose_bucket" {
  for_each = toset(var.aws_s3_bucket_names)
  bucket     = each.value
}

# 2. Enable encryption
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = toset(var.aws_s3_bucket_names)
  bucket = each.value
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Block public access
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  for_each = toset(var.aws_s3_bucket_names)
  bucket = each.value
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Block public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  for_each = toset(var.aws_s3_bucket_names)
  bucket = each.value

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}