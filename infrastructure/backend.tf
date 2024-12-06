terraform {
  backend "gcs" {
    bucket = "3667448573731b54-terraform-backend-infrastructure"
    prefix = "env/infrastructure"
  }
}
