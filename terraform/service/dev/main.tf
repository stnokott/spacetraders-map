module "service" {
  source    = "../"
  env       = "dev"
  image_tag = var.image_tag
}

output "public_uri" {
  value = module.service.public_uri
}
