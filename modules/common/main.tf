module "services" {
  source   = "../../modules/services"
  project  = var.project
  services = ["storage.googleapis.com", "cloudbuild.googleapis.com"]
}

data "google_project" "project" {}

resource "google_project_iam_binding" "project" {
  project = var.project
  role    = "roles/editor"

  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
  ]
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

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.root}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.terraform-backend.name}"
      prefix = "env/${var.env}"
    }
  }
  EOT
}
