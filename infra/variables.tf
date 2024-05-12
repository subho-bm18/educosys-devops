variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "us-west-2"
}

variable "stack_name" {}
variable "environment" {}
variable "internal_subnets" {
  type = list(string)
}
variable "external_subnets" {
  type = list(string)
}
variable "availability_zones" {
  description = "A list of availability zones in which to create subnets"
  type        = list(string)
}
variable "billing" {}
variable "component" {}
