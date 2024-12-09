terraform {
  backend "gcs" {
    bucket = "terraform-backend-prod-b2cc000827b28c97"
    prefix = "terraform/state"
  }
}
