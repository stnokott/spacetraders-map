locals {
  env = "dev"
}

provider "google" {
  project = var.project
  zone    = var.zone
}

module "backend" {
  source  = "../../modules/backend"
  project = var.project
  env     = local.env
  region  = provider::google::region_from_zone(var.zone)
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
  env     = local.env
  region  = provider::google::region_from_zone(var.zone)
}

module "http_server" {
  source  = "../../modules/http_server"
  project = var.project
  subnet  = module.vpc.subnet
  zone    = var.zone
}

module "firewall" {
  source  = "../../modules/firewall"
  project = var.project
  subnet  = module.vpc.subnet
}

##############
# BEGIN NEW
##############

module "gcp_apis" {
  source  = "../../modules/gcp_apis"
  project = var.project
  apis    = ["run.googleapis.com"]
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
  name     = "server-${local.env}"
  location = provider::google::region_from_zone(var.zone)

  deletion_protection = false

  template {
    containers {
      image = "${provider::google::region_from_zone(var.zone)}-docker.pkg.dev/${var.project}/${module.common_vars.artifact_repository_name}/${module.common_vars.server_image_name}:${local.env}"
    }
    service_account = google_service_account.cloudrun_service_account.email

    vpc_access {
      network_interfaces {
        subnetwork = module.vpc.subnet
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

##############
# END NEW
##############
