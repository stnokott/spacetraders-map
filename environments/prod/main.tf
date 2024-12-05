locals {
  env = "prod"
}

provider "google" {
  project = var.project
}

module "common" {
  source  = "../../modules/common"
  project = var.project
  env     = local.env
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
