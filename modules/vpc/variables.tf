variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
variable "name" {
  description = "The name of the VPC"
  type        = string
}
variable "cidr" {}
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
variable "environment" {}
variable "billing" {}
variable "component" {}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-west-2"
}
