variable "key_name" {
  description = "The name of the SSH key pair to attach to the EC2 instances"
}

variable "private_key_path" {
  description = "The path to the private SSH key to connect to the instances"
  default ="test"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
}

variable "security_group_id" {
  description = "The ID of the security group"
}
variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instances will be created"
}
