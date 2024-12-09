module "common_vars" {
  source = "../modules/common_vars"
}

provider "google" {
  project = module.common_vars.project
  zone    = module.common_vars.zone
}

module "backend" {
  source  = "../modules/backend"
  project = module.common_vars.project
  env     = "infrastructure"
  region  = provider::google::region_from_zone(module.common_vars.zone)
}
