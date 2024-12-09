terraform {
  backend "gcs" {
    bucket = "terraform-backend-dev-f2b0c075b2b4a076"
    prefix = "terraform/state"
  }
}
