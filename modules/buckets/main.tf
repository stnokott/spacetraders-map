module "services" {
  source   = "../../modules/services"
  project  = var.project
  services = ["storage.googleapis.com"]
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "terraform-backend" {
  project  = var.project
  name     = "${random_id.default.hex}-terraform-remote-backend"
  location = "US"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
