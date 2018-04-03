variable "create_elb" {
  description = "The triger for creating Load Balancer"
}

variable "create_elb_nodes" {
  description = "The triger for creating Load Balancer"
}

variable "number_of_nodes" {
  description = "The triger for creating Load Balancer"
}

variable "aws_default_sg" {
  description = "The "
}

variable "tags" {
  description = "The "
}

variable "aws_security_groups" {
  description = "The "
  type        = "list"
}

variable "aws_vpc_network" {
  description = "The "
}

variable "aws_vpc_id" {
  description = "The "
}

variable "create_sg" {
  description = "The "
}

variable "aws_elb_sg_names" {
  description = "The "
  type        = "list"
}

variable "aws_elb_sg_ports" {
  description = "The "
  type        = "list"
}

variable "aws_nodes_sg_names" {
  description = "The "
  type        = "list"
}

variable "aws_nodes_sg_ports" {
  description = "The "
  type        = "list"
}

variable "aws_ami" {
  description = "ID of AMI to use for the instance"
}

variable "ec2_monitoring" {
  description = "The "
}

variable "aws_instance_type" {
  description = "The "
}

variable "aws_public_subnet_1" {
  description = "The "
}

variable "aws_public_subnet_2" {
  description = "The "
}

variable "aws_public_subnets" {
  description = "The "
  type        = "list"
}

#variable "create_load_balancer" {
#  description = "The triger for creating Load Balancer"
#  type        = "map"
#
#  default = {
#    elb       = "1"
#    elb_nodes = "2"
#  }
#}


#variable "" {
#	description	= "The "
#}

