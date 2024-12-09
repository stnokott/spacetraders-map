output "network" {
  value = module.vpc.network
}

output "subnet" {
  value = module.vpc.subnet
}

output "firewall_rule" {
  value = module.firewall.firewall_rule
}

output "instance_name" {
  value = module.run.service_name
}
output "public_uri" {
  value = module.run.public_uri
}
