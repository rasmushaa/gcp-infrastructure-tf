output "bucket_name" {
  description = "Name of the Cloud Storage bucket."
  value       = google_storage_bucket.this.name
  sensitive   = true
}

output "bucket_url" {
  description = "Cloud Storage URL of the bucket."
  value       = google_storage_bucket.this.url
  sensitive   = true
}
