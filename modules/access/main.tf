data "google_project" "project" {
}

resource "google_project_iam_binding" "project" {
  project = data.google_project.project.id
  role    = "roles/editor"

  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
  ]
}
