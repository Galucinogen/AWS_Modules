variable "customer_name" {
  description = "The Customer name"
}

variable "create_vpn" {
  description = "The trigger for createing VPN to Customer"
}

variable "vpn_gateway_id" {
  description = "The ID of VPN Gateway"
}

variable "vpc_subnet_ids" {
  description = "The IDs of VPC subnets"
  type        = "list"
}

variable "customer_vpn_ip" {
  description = "The customer VPN IP"
}

variable "aws_vpc_id" {
  description = "The ID of AWS VPC"
}

variable "customer_subnets" {
  description = "The Customers subnets"
  type        = "list"
}
