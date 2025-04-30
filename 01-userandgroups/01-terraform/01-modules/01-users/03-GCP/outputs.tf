output "service_account_details" {
  description = "Map of service account details including email and unique IDs"
  value = {
    for key, sa in google_service_account.service_account : key => {
      email        = sa.email
      account_id   = sa.account_id
      unique_id    = sa.unique_id
      display_name = sa.display_name
    }
  }
}

output "service_account_keys" {
  description = "Map of service account keys (sensitive)"
  value = {
    for key, sa_key in google_service_account_key.key : key => {
      private_key = sa_key.private_key
      public_key  = sa_key.public_key
    }
  }
  sensitive = true # Important: Mark as sensitive since it contains private keys
}