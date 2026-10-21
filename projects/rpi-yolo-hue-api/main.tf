resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  project       = var.project_id
  location      = "EUROPE-NORTH1"
  storage_class = "STANDARD"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  # Hierarchical namespace is intentionally omitted. Slash-delimited object
  # names provide normal folder-style organization with broad compatibility.
  versioning {
    enabled = false
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }
}
