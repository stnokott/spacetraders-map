module "services" {
  source   = "../services"
  project  = var.project
  services = ["storage.googleapis.com"]
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "terraform-backend" {
  project  = var.project
  name     = "${random_id.default.hex}-terraform-backend"
  location = "US"

  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
