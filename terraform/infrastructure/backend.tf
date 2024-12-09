terraform {
  backend "gcs" {
    bucket = "3f8083534124deb0-terraform-backend-infrastructure"
    prefix = "env/infrastructure"
  }
}
