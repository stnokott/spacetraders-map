terraform {
  backend "gcs" {
    bucket = "dbd276d4cd09fb33-terraform-backend-prod"
    prefix = "env/prod"
  }
}
