# outputs.tf
output "bucket_urls" {
  description = "Map of bucket names to their URLs"
  value = {
    for bucket in google_storage_bucket.gcp_storage_buckets_main :
    bucket.name => bucket.url
  }
}

output "bucket_self_links" {
  description = "Map of bucket names to their self links"
  value = {
    for bucket in google_storage_bucket.gcp_storage_buckets_main :
    bucket.name => bucket.self_link
  }
}
