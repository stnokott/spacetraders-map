terraform {
  backend "gcs" {
    bucket = "7e0a3905c3adbbd5-terraform-backend-dev"
    prefix = "env/dev"
  }
}
