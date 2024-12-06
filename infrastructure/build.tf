# create Artifact Registry repository
resource "google_artifact_registry_repository" "default" {
  location      = provider::google::region_from_zone(var.zone)
  repository_id = "spacetraders-map-repo"
  description   = "Container registry for Spacetraders Map project"
  format        = "docker"

  // TODO: set to false once correct policies are confirmed
  cleanup_policy_dry_run = true

  // keep [prod] images
  cleanup_policies {
    id     = "keep-all-prod"
    action = "KEEP"
    condition {
      tag_state    = "TAGGED"
      tag_prefixes = ["prod"]
    }
  }

  // keep 5 most recent [dev] images
  cleanup_policies {
    id     = "delete-old-dev"
    action = "DELETE"
    condition {
      tag_state    = "TAGGED"
      tag_prefixes = ["dev"]
      older_than   = format("%ds", 7 * 24 * 60 * 60) // 7 days
    }
  }
  depends_on = [module.gcp_apis]
}

locals {
  github_repo_url                    = "https://github.com/stnokott/spacetraders-map.git"
  github_cloud_build_installation_id = 57972476 // from https://github.com/settings/installations
  github_token_secret_id             = "github_token_secret"
}

// token needs to be set manually after secret creation, see https://cloud.google.com/secret-manager/docs/add-secret-version#secretmanager-add-secret-version-gcloud
resource "google_secret_manager_secret" "github_token_secret" {
  project   = var.project
  secret_id = local.github_token_secret_id

  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "github_token" {
  secret     = local.github_token_secret_id
  depends_on = [google_secret_manager_secret.github_token_secret]
}

data "google_project" "project" {}

// Create Cloud Build service account
resource "google_service_account" "cloudbuild_service_account" {
  account_id                   = "cloudbuild-sa"
  display_name                 = "cloudbuild-sa"
  description                  = "Cloud build service account"
  create_ignore_already_exists = true
}

resource "google_project_iam_member" "cloudbuild_service_account" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "cloudbuild_logs" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

data "google_iam_policy" "cloudbuild_secrets" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      // required for establishing a repo connection to GitHub
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
      // required for creating and running triggers
      "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.cloudbuild_secrets.policy_data
  depends_on  = [google_project_iam_member.cloudbuild_service_account]
}

// Create GitHub connection
resource "google_cloudbuildv2_connection" "github-connection" {
  project  = var.project
  location = provider::google::region_from_zone(var.zone)
  name     = "github-connection"

  github_config {
    app_installation_id = local.github_cloud_build_installation_id
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.github_token.name
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

// Link repository
resource "google_cloudbuildv2_repository" "github-repo" {
  name              = "github-repo"
  location          = provider::google::region_from_zone(var.zone)
  parent_connection = google_cloudbuildv2_connection.github-connection.name
  remote_uri        = local.github_repo_url
}

// Create build trigger
resource "google_cloudbuild_trigger" "github-build-trigger" {
  name            = "github-push-to-branch"
  location        = google_cloudbuildv2_connection.github-connection.location
  service_account = google_service_account.cloudbuild_service_account.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.github-repo.id
    push {
      branch = ".*"
    }
  }

  filename = "cloudbuild.yaml"
}
