variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "enable_single_nat_gateway" {
  type = bool
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_key_name" {
  type = string
}

variable "jenkins_instance_values" {
  type = list(object({
    name = string
    efs_mount_point = string
    master = bool
  }))
}
