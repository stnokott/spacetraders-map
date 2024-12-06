terraform {
  backend "gcs" {
    bucket = "d4827035a70a4c16-terraform-backend-dev"
    prefix = "env/dev"
  }
}
