variable "gcp_project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_service_account_names" {
  description = "Map of service account configurations"
  type = map(object({
    display_name = string
    description  = string
    gcp_role     = string
  }))
}
