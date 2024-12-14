terraform {
  backend "gcs" {
    bucket = "terraform-backend-preprod-7788dcfd99596c68"
    prefix = "terraform/state"
  }
}
