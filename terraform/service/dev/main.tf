module "service" {
  source = "../"
  env    = "dev"
}

output "public_uri" {
  value = module.service.public_uri
}
