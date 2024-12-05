terraform {
  backend "gcs" {
    bucket = "015903a693674873-terraform-backend"
    prefix = "env/dev"
  }
}
