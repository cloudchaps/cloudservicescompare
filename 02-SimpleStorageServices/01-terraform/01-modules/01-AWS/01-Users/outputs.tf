output "aws_iam_user_name" {
    description = "List of created IAM user names"
    value = [for user in var.user_names : user]
}