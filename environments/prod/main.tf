locals {
  env = "prod"
}

provider "google" {
  project = var.project
}

module "buckets" {
  source  = "../../modules/buckets"
  project = var.project
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${module.buckets.name_terraform}"
      prefix = "env/dev"
    }
  }
  EOT
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
