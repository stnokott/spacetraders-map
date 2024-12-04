module "buckets" {
  source  = "../../modules/buckets"
  project = var.project
}

terraform {
  backend "gcs" {
    bucket = module.buckets.name_terraform
    prefix = "env/prod"
  }
}
