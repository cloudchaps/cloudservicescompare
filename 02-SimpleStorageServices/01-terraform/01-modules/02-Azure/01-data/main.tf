# main.tf

# 1. Resource Group
resource "azurerm_resource_group" "azure_cloudchaps_resourcegroups" {
  for_each = var.azure_resource_groups
  name     = each.key
  location = each.value.location
}

# 2. Storage Account
resource "azurerm_storage_account" "azure_cloudchaps_storageaccounts" {
  for_each = {
    for item in flatten ([
      for rg_key, rg_value in var.azure_resource_groups : [ 
        for sa in rg_value.storage_account_names : {
#          key                      = "${rg_key}-${sa.name}"
          name                     = sa.name
          resource_group_name      = azurerm_resource_group.azure_cloudchaps_resourcegroups[rg_key].name,
          location                 = rg_value.location
          account_tier             = sa.account_tier
          account_replication_type = sa.account_replication_type
        }
      ]
    ]) : item.name => item
  }
  name                     = substr(lower(replace(each.value.name, "-", "")), 0, 24) 
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Security settings
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  depends_on = [azurerm_resource_group.azure_cloudchaps_resourcegroups]
}

# 3. Storage Container
resource "azurerm_storage_container" "azure_cloudchaps_storagecontainers" {
  for_each = {
    for item in flatten ([
      for rg_key, rg_value in var.azure_resource_groups : [
        for container in rg_value.containers : {
#          key                   = "${rg_key}-${container.name}" 
          name                  = container.name
          storage_account_name  = container.storage_account_name
          container_access_type = container.container_access_type
        }
      ]
    ]) : item.name => item
  }

  name                  = substr(lower(replace(each.value.name, "-", "")), 0, 24)
  storage_account_name  = substr(lower(replace(each.value.storage_account_name, "-", "")), 0, 24)
  container_access_type = each.value.container_access_type

  depends_on = [azurerm_storage_account.azure_cloudchaps_storageaccounts]
}
