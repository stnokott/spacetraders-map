module "service" {
  source    = "../"
  env       = "preprod"
  image_tag = var.image_tag
}

output "public_uri" {
  value = module.service.public_uri
}
