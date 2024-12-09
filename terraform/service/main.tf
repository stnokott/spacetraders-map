module "common_vars" {
  source = "../modules/common_vars"
}

provider "google" {
  project = module.common_vars.project
  zone    = module.common_vars.zone
}

locals {
  // Our Environment is controlled by the workspace.
  // The Cloud Build pipeline will select the appropriate workspace before running Terraform commands.
  env = terraform.workspace
}

//
// The following resources are all environment-specific, so we use the "env" variable for controlling behaviour.
//

module "backend" {
  source   = "../modules/backend"
  project  = module.common_vars.project
  env      = terraform.workspace
  region   = provider::google::region_from_zone(module.common_vars.zone)
  filename = "backend_${terraform.workspace}"
}

module "vpc" {
  source  = "../modules/vpc"
  project = module.common_vars.project
  env     = terraform.workspace
  region  = provider::google::region_from_zone(module.common_vars.zone)
}

module "firewall" {
  source  = "../modules/firewall"
  project = module.common_vars.project
  subnet  = module.vpc.subnet
}

module "run" {
  source  = "../modules/run"
  project = module.common_vars.project
  env     = terraform.workspace
  region  = provider::google::region_from_zone(module.common_vars.zone)
  network = module.vpc.network
  subnet  = module.vpc.subnet
}
