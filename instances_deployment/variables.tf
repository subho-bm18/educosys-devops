variable "key_name" {}
variable "private_key_path" {
    default= "test"
}
variable "instance_type" {}
variable "ami_id" {}
variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instances will be created"
}
