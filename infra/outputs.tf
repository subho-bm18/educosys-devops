output "vpc_id" {
  value = module.vpc.vpc_id
}

output "internal_subnet_ids" {
  value = module.vpc.internal_subnet_ids
}

output "external_subnet_ids" {
  value = module.vpc.external_subnet_ids
}
