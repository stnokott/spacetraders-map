locals {
  env = "dev"
}

provider "google" {
  project = var.project
}

module "services" {
  source   = "../../modules/services"
  project  = var.project
  services = ["cloudbuild.googleapis.com"]
}

module "access" {
  source = "../../modules/access"
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
  env     = local.env
}

module "http_server" {
  source  = "../../modules/http_server"
  project = var.project
  subnet  = module.vpc.subnet
}

module "firewall" {
  source  = "../../modules/firewall"
  project = var.project
  subnet  = module.vpc.subnet
}
