output "azure_user_data" {
  description = "Azure users info"
  value = [for user in var.azure_user_data : {
    display_name = user["display_name"]
    password = user["password"]
  }]
}

output "azure_group_name" {
    description = "Azure group name"
    value = var.azure_group_name
}

output "role_name" {
    description = "Azure role name"
    value = var.azure_role_definition_name
}