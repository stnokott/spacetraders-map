terraform {
  backend "gcs" {
    bucket = "19a2a6178eb81669-terraform-backend-infrastructure"
    prefix = "env/infrastructure"
  }
}
