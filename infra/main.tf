module "vpc" {
  source             = "../modules/vpc"
  name               = "${var.stack_name}-${var.environment}"
  cidr               = "10.0.0.0/16"
  internal_subnets   = var.internal_subnets
  external_subnets   = var.external_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
  billing            = var.billing
  component          = var.component
}
