terraform {
  backend "gcs" {
    bucket = "terraform-backend-dev-c03dccc034bf731b"
    prefix = "terraform/state"
  }
}
