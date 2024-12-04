data "google_project" "project" {
}

data "google_iam_policy" "cloudbuild" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}
