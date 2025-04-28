variable "user_names" {
    description = "user_names"
    type = list(string)
#    default = ["Username1", "Username2", "Username3"]
}

variable "aws_iam_user_policy_name" {
    description = "aws_iam_user_policy_name"
    type = string
}
