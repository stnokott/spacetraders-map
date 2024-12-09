resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "terraform-backend" {
  project  = var.project
  name     = "${random_id.default.hex}-terraform-backend-${var.env}"
  location = var.region

  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.root}/${var.filename}.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.terraform-backend.name}"
      prefix = "env/${var.env}"
    }
  }
  EOT
}
