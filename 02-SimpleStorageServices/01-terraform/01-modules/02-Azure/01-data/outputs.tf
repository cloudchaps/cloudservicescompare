output "azure_resource_groups" {
    description = "List of created IAM user names"
    value = [for rg in var.azure_resource_groups : rg] 
}