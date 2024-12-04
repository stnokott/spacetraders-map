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
