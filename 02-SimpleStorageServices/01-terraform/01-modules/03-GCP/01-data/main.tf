# main.tf
resource "google_storage_bucket" "gcp_storage_buckets_main" {
  for_each = {
    for bucket in var.storage_buckets : bucket.name => bucket
  }

  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy
  storage_class = each.value.storage_class

  # Enable versioning
  versioning {
    enabled = each.value.versioning_enabled
  }

  # Security best practices
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Configure retention policy if specified
  dynamic "retention_policy" {
    for_each = each.value.retention_period_days != null ? [1] : []
    content {
      retention_period = each.value.retention_period_days * 24 * 60 * 60
      is_locked       = each.value.retention_policy_locked
    }
  }

  # Lifecycle rules
  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rules
    content {
      condition {
        age                   = lifecycle_rule.value.age
        created_before        = lifecycle_rule.value.created_before
        with_state           = lifecycle_rule.value.with_state
        matches_storage_class = lifecycle_rule.value.matches_storage_class
      }
      action {
        type          = lifecycle_rule.value.action_type
        storage_class = lifecycle_rule.value.target_storage_class
      }
    }
  }
}
