provider "google" {
  project = var.project
  zone    = var.zone
}

module "backend" {
  source  = "../modules/backend"
  project = var.project
  env     = "infrastructure"
  region  = provider::google::region_from_zone(var.zone)
}
