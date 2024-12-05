terraform {
  backend "gcs" {
    bucket = "aae1f6c28ff1d844-terraform-backend"
    prefix = "env/prod"
  }
}
