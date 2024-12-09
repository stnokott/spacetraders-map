terraform {
  backend "gcs" {
    bucket = "cb326e6537b50cab-terraform-backend-dev"
    prefix = "env/dev"
  }
}
