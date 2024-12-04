terraform {
  backend "gcs" {
    bucket = "a949697647c534d8-terraform-backend"
    prefix = "env/prod"
  }
}
