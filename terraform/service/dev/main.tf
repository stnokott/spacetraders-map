module "service" {
  source = "../"
  env    = "dev"
}

output "instance_name" {
  value = module.service.instance_name
}
output "public_uri" {
  value = module.service.public_uri
}
