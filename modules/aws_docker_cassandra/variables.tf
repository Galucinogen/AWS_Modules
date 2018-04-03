variable "create_cassandra" {
  description = "The trigger for creating Cassandra"
}

variable "aws_vpc_id" {
  description = "The ID of AWS VPC"
}

variable "aws_instance_type" {
  description = "The AWS EC2 Instance type"
}

variable "number_of_nodes" {
  description = "The number of nodes"
}

variable "aws_ami" {
  description = "The AWS AMI"
}

variable "aws_private_subnets" {
  description = "The AWS Private subnets"
  type        = "list"
}

variable "aws_vpc_network" {
  description = "The AWS VPC Network"
}

variable "ec2_monitoring" {
  description = "The CloudWatch"
}

variable "aws_availability_zones" {
  description = "The Availability Zones"
  type        = "list"
}

variable "tags" {
  description = "The Tags"
}

variable "aws_security_groups" {
  description = "The Security Groups"
  type        = "list"
}

variable "aws_bastion_ip" {
  description = "The AWS Bastion IP"
}

#variable "" {
#  description = "The "
#}

