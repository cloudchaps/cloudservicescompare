# 1. IAM User requirements
resource "aws_iam_user" "aws_user" {
    for_each = toset(var.user_names)
    name = each.value
}

# 3. Add IAM User Policies
resource "aws_iam_user_policy" "aws_user_policy" {
  name = var.aws_iam_user_policy_name
  for_each = toset(var.user_names)
  user = each.value

  policy = fileexists("../../../aws-user-policy.json") ? file("../../../aws-user-policy.json") : null
  depends_on = [ aws_iam_user.aws_user ]
} 

# 2. Add IAM password policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers               = true
  require_uppercase_characters   = true
  require_symbols               = true
  password_reuse_prevention     = 24
  max_password_age             = 90
}