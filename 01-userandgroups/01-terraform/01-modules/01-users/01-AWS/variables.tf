variable "user_names" {
    description = "user_names"
    type = list(string)
    default = ["Username1", "Username2", "Username3"]
}

variable "aws_iam_user_policy_name" {
    description = "aws_iam_user_policy_name"
    type = string
}

variable "aws_iam_group_name" {
    description = "aws_iam_group_name"
    type = string
}

variable "aws_iam_group_membership_name" {
    description = "aws_iam_group_membership_name"
    type = string
}

variable "aws_iam_group_policy_name" {
    description = "aws_iam_group_policy_name"
    type = string
}

variable "aws_iam_role_name" {
    description = "aws_iam_role_name"
    type = string
}

variable "aws_role_policy" {
    description = "aws_role_policy"
    type = string
}