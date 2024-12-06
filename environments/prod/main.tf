locals {
  env = "prod"
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
