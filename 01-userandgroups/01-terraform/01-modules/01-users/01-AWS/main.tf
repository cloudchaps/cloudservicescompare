resource "aws_iam_user" "aws_user" {
    for_each = toset(var.user_names)
    name = each.value
}

resource "aws_iam_user_policy" "aws_user_policy" {
  name = var.aws_iam_user_policy_name
  for_each = toset(var.user_names)
  user = each.value

  policy = file("../../../aws-user-policy.json")
  depends_on = [ aws_iam_user.aws_user ]
} 

resource "aws_iam_group" "aws_group" {
  name = var.aws_iam_group_name
}

resource "aws_iam_group_membership" "aws_group_membership" {
  name = var.aws_iam_group_membership_name
  users = [for user in aws_iam_user.aws_user : user.name]
  group = aws_iam_group.aws_group.name
  depends_on = [ aws_iam_user.aws_user, aws_iam_group.aws_group ]
}

resource "aws_iam_group_policy" "aws_group_policy" {
  name = var.aws_iam_group_policy_name
  group = aws_iam_group.aws_group.name
  policy = file("../../../aws-group-policy.json")
}

resource "aws_iam_role" "aws_role" {
  name = var.aws_iam_role_name
  assume_role_policy = file("../../../aws-role-policy.json")
}