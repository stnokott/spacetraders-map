module "gcp_apis" {
  source  = "../modules/gcp_apis"
  project = module.common_vars.project
  apis    = ["storage.googleapis.com", "cloudbuild.googleapis.com", "secretmanager.googleapis.com", "artifactregistry.googleapis.com"]
}
