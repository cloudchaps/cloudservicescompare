# 1. Azure Resource Group Variables
variable "azure_resource_groups" {
    description = "Map of Azure Resource Groups with their associated storage account configurations"
    type = map(object({
        location = string
        storage_account_names = list(object({
            name = string
            account_tier = string
            account_replication_type = string
        }))
        containers = list(object({
            name = string
            storage_account_name = string
            container_access_type = string
        }))
    }))
}