output "service_name" {
  value = google_cloud_run_v2_service.default.name
}
output "public_uri" {
  value = google_cloud_run_v2_service.default.uri
}
