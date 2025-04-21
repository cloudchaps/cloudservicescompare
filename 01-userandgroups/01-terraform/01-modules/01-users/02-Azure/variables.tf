variable "azure_user_data" {
    description = "Azure User names"
    type = map(object({
        display_name = string
        password = string
    }))
}
variable "azure_group_name" {
    description = "Azure Group name"
    type = string
}
variable "azure_role_definition_name"{ 
    description = "Azure ROLE Definition name"
    type = string
}

variable "azure_domain" {
    description = "Azure Domain name"
    type = string
}
variable "azure_subscription_id" {
    description = "Azure Subscription ID"
    type = string
}