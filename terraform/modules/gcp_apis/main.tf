resource "google_project_service" "gcp_apis" {
  for_each = toset(var.apis)
  service  = each.value

  disable_on_destroy = false
}
