output "aws_iam_user_name" {
    description = "List of created IAM user names"
    value = [for user in var.user_names : user]
}

output "aws_iam_group" {
    value = aws_iam_group.aws_group.name
}

output "aws_iam_role" {
    value = aws_iam_role.aws_role.name
}