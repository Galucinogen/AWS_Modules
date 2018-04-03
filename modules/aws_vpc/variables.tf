variable "create_vpc" {
  description = "The trigger for creating VPC"
}

variable "enable_nat_gateway" {
  description = "The trigger for creating NAT Gateway"
}

variable "aws_vpc_name" {
  description = "The name of VPC name"
}

variable "aws_vpc_network" {
  description = "The AWS VPC Network"
}

variable "aws_private_subnets" {
  description = "The list of private subnets"
  type        = "list"
}

variable "aws_public_subnets" {
  description = "The list of public subnets"
  type        = "list"
}

variable "aws_availability_zones" {
  description = "The AWS Availability Zones"
  type        = "list"
}

variable "enable_vpn_gateway" {
  description = "The trigger for creatre VPN gateway"
}

#variable "" {
#  description = "The "
#}

