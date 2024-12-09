module "service" {
  source = "../"
  env    = "prod"
}

output "public_uri" {
  value = module.service.public_uri
}
