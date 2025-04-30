module "user1" {
  source                        = "../../01-modules/01-users/01-AWS"
  user_names                    = ["AWS-CloudChapsUser", "AWS-CloudChapsUserTwo", "AWS-CloudChapsUserThree"]
  aws_iam_user_policy_name      = "AWS-CloudChapsUserPolicy"
  aws_iam_group_name            = "AWS-CloudChapsGroup"
  aws_iam_group_policy_name     = "AWS-CloudChapsGroupPolicy"
  aws_iam_role_name             = "AWS-CloudChapsRole"
  aws_iam_group_membership_name = "AWS-CloudChapsTeam"
  aws_role_policy               = "AWS-CloudChapsRolePolicy"
}

module "azure_users" {
  source = "../../01-modules/01-users/02-Azure"
  azure_user_data = {
    "Azure-CloudChaps-UserOne" = {
      display_name = "Azure-CloudChaps-Master"
      password     = "ComplexPassword1"
    }
    "Azure-CloudChaps-UserTwo" = {
      display_name = "Azure-CloudChaps-Worker1"
      password     = "ComplexPassword2"
    }
    "Azure-CloudChaps-UserThree" = {
      display_name = "Azure-CloudChaps-Worker2"
      password     = "ComplexPassword3"
    }
  }
  azure_group_name           = "Azure-CloudChapsGroup"
  azure_role_definition_name = "Contributor"
  azure_domain               = "danyboyvonderrosegmail.onmicrosoft.com"
  azure_subscription_id      = "b4e4597c-2535-40c8-b0f3-2dc02047eeeb"
}

module "sa_example" {
  source         = "../../01-modules/01-users/03-GCP"
  gcp_project_id = "devopspracticeproject"
  gcp_service_account_names = {
    "gcp-cloudchaps-compute-admin" = {
      display_name = "GCP-CloudChaps-ServiceAccount-Compute"
      description  = "Used for managing compute API resources"
      gcp_role     = "roles/compute.admin"
    }
    "gcp-cloudchaps-sql-admin" = {
      display_name = "GCP-CloudChaps-ServiceAccount-Database"
      description  = "Used for managing database resources"
      gcp_role     = "roles/cloudsql.admin"
    }
  }
}
