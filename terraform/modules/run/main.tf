module "gcp_apis" {
  source  = "../../modules/gcp_apis"
  project = var.project
  apis    = ["compute.googleapis.com", "run.googleapis.com", "cloudresourcemanager.googleapis.com"]
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

// Query server image from registry so that we can get its URI for the deployment.
data "google_artifact_registry_docker_image" "server_image" {
  location      = var.region
  repository_id = module.common_vars.artifact_repository_name
  // Use image tagged with environment
  image_name = "${module.common_vars.server_image_name}:${var.env}"
}

// Create service
resource "google_cloud_run_v2_service" "default" {
  name     = "server-${var.env}"
  location = var.region

  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"
  traffic {
    // always send traffic to latest revision only
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  template {
    service_account = google_service_account.cloudrun_service_account.email
    containers {
      // `self_link` contains the full hash of the image.
      // This means that when the image is updated, the hash changes and Terraform recreates the service.
      // If we used a static, tagged image name (e.g. "image:dev"), this would not happen as Terraform wouldn't know the deployment requires an update.
      image = data.google_artifact_registry_docker_image.server_image.self_link
    }
    scaling {
      min_instance_count = 1
      max_instance_count = 1
    }

    vpc_access {
      network_interfaces {
        network    = var.network
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
