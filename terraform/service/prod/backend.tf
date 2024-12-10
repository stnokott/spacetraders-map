terraform {
  backend "gcs" {
    bucket = "terraform-backend-prod-929f3dcef258061e"
    prefix = "terraform/state"
  }
}
