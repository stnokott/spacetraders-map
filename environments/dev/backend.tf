terraform {
  backend "gcs" {
    bucket = "7ab0f1e1bb84316e-terraform-backend"
    prefix = "env/dev"
  }
}
