# variables.tf
variable "storage_buckets" {
  description = "List of storage buckets to create"
  type                            = list(object({
    name                          = string
    location                      = string
    force_destroy                 = bool
    storage_class                 = string
    versioning_enabled            = bool
    retention_period_days         = optional(number)
    retention_policy_locked       = optional(bool, false)
     lifecycle_rules              = list(object({
      age                         = optional(number)
      created_before              = optional(string)
      with_state                  = optional(string)
      matches_storage_class       = optional(list(string))
      action_type                 = string
      target_storage_class        = optional(string)
    }))
  }))
}
