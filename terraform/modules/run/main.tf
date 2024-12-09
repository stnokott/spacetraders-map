module "gcp_apis" {
  source  = "../../modules/gcp_apis"
  project = var.project
  apis    = ["compute.googleapis.com", "run.googleapis.com"]
}

module "common_vars" {
  source = "../../modules/common_vars"
}

// Create Cloud Run service account
resource "google_service_account" "cloudrun_service_account" {
  account_id                   = "cloudrun-sa"
  display_name                 = "cloudrun-sa"
  description                  = "Cloud Run service account"
  create_ignore_already_exists = true
}

// Grant Service Account role
resource "google_project_iam_member" "cloudrun_service_account" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
}

resource "google_cloud_run_v2_service" "default" {
  name     = "server-${var.env}"
  location = var.region

  deletion_protection = false

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project}/${module.common_vars.artifact_repository_name}/${module.common_vars.server_image_name}:${var.env}"
    }
    service_account = google_service_account.cloudrun_service_account.email

    vpc_access {
      network_interfaces {
        subnetwork = var.subnet
        tags       = ["http-server"]
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
