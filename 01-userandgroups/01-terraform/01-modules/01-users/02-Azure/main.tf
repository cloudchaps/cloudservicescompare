resource "azuread_user" "azure_user" {
    for_each = var.azure_user_data
    user_principal_name = "${each.key}@${var.azure_domain}"
    display_name = each.value.display_name
    password = each.value.password
}

resource "azuread_group" "azure_group" {
  display_name     = var.azure_group_name
  security_enabled = true
}

resource "azuread_group_member" "example" {
  for_each = var.azure_user_data
  
  group_object_id  = azuread_group.azure_group.object_id
  member_object_id = azuread_user.azure_user[each.key].object_id
  # Add explicit dependency
  depends_on = [
    azuread_user.azure_user,
    azuread_group.azure_group
  ]

  # Add lifecycle rules to handle existing members
  lifecycle {
    ignore_changes = [
      # Ignore changes to members that might be added outside of Terraform
      member_object_id
    ]
  }
}

resource "azurerm_role_assignment" "example" {
  for_each = var.azure_user_data
  
  principal_id           = azuread_user.azure_user[each.key].object_id
  role_definition_name   = var.azure_role_definition_name
  scope                  = "/subscriptions/${var.azure_subscription_id}"

  depends_on = [
    azuread_user.azure_user
  ]
}