resource "google_service_account" "service_account" {
  project      = var.gcp_project_id
  for_each     = var.gcp_service_account_names
  account_id   = each.key
  display_name = each.value.display_name
  description  = each.value.description
}

resource "google_project_iam_member" "service_account_role" {
    project  = var.gcp_project_id
    for_each = var.gcp_service_account_names
    role     = each.value.gcp_role
    member   = "serviceAccount:${google_service_account.service_account[each.key].email}"

    depends_on = [
      google_service_account.service_account
    ]
}

resource "google_service_account_key" "key" {
    for_each           = var.gcp_service_account_names
    service_account_id = google_service_account.service_account[each.key].name
    keepers = {
        service_account_email = google_service_account.service_account[each.key].email
    }

    depends_on = [
      google_service_account.service_account
    ]
}
