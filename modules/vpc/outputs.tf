output "network" {
  value       = module.vpc.network
  description = "VPC id"
}

output "subnets" {
  value       = module.vpc.subnets
  description = "VPC subnets map"
}