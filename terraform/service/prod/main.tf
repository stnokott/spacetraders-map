module "service" {
  source = "../"
  env    = "prod"
}

output "instance_name" {
  value = module.service.service_name
}
output "public_uri" {
  value = module.service.public_uri
}
