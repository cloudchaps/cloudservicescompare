module "CloudChapsUser" {
  source                   = "../../../01-terraform/01-modules/01-AWS/01-Users"
  user_names               = ["AWS-CloudChapsUser", "AWS-CloudChapsUserTwo", "AWS-CloudChapsUserThree"]
  aws_iam_user_policy_name = "AWS-CloudChapsUserPolicy"
}

module "CloudChapsS3Bucket" {
  source              = "../../../01-terraform/01-modules/01-AWS/02-data"
  aws_s3_bucket_names = ["aws-cloudchaps-bucket-01", "aws-cloudchaps-bucket-02", "aws-cloudchaps-bucket-03"]
}

module "azure_resource_group_storage_account_storage_container" {
  source = "../../../01-terraform/01-modules/02-Azure/01-data"
  azure_resource_groups = {
    "cc-resourcegroup" = {
      location = "eastus"
      storage_account_names = [{
        name                     = "Azure-CloudChaps-Storage-Account-01"
        account_tier             = "Standard"
        account_replication_type = "LRS"
      }]
      containers = [
        {
          name                  = "01-CloudChaps-AZ-Storage-Container"
          storage_account_name  = "Azure-CloudChaps-Storage-Account-01"
          container_access_type = "private"
        },
        {
          name                  = "02-CloudChaps-AZ-Storage-Container"
          storage_account_name  = "Azure-CloudChaps-Storage-Account-01"
          container_access_type = "private"
        },
        {
          name                  = "03-CloudChaps-AZ-Storage-Container"
          storage_account_name  = "Azure-CloudChaps-Storage-Account-01"
          container_access_type = "private"
        }
      ]
    }
  }
}

module "gcp_storage" {
  source = "../../../01-terraform/01-modules/03-GCP/01-data/"

  storage_buckets = [
    {
      name               = "cloudchaps-storagebucket-01"
      location           = "US"
      force_destroy      = false
      storage_class      = "STANDARD"
      versioning_enabled = true
      kms_key_name       = "projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key"
      lifecycle_rules = [
        {
          age                  = 90
          action_type          = "SetStorageClass"
          target_storage_class = "COLDLINE"
        }
      ]
    }
  ]
}




