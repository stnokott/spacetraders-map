terraform {
  backend "gcs" {
    bucket = "terraform-backend-infra-12e73411ea96751a"
    prefix = "terraform/state"
  }
}
