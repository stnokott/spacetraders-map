terraform {
  backend "gcs" {
    bucket = "78cb36c97fbdda53-terraform-backend-prod"
    prefix = "env/prod"
  }
}
