output "aws_s3_bucket" {
    description = "List of created IAM user names"
    value = [for bucket in var.aws_s3_bucket_names : bucket] 
}

