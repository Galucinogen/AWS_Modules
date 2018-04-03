variable "create_bastion" {
  description = "The trigger for creating Bastion"
}

variable "create_sg" {
  description = "The trigger for creating Security Group"
}

variable "aws_ami" {
  description = "ID of AMI to use for the instance"
}

variable "ec2_monitoring" {
  description = "The CloudWatch"
}

variable "aws_instance_type" {
  description = "The AWS EC2 Instance type"
}

variable "aws_subnet" {
  description = "The AWS Subnet"
}

variable "tags" {
  description = "The Tags"
}

variable "aws_vpc_network" {
  description = "The AWS VPC Network"
}

variable "aws_vpc_id" {
  description = "The ID of AWS VPC"
}

variable "aws_security_groups" {
  description = "The AWS Security Groups"
  type        = "list"
}

variable "number_of_instances" {
  description = "The number of Instance"
}

variable "user_data" {
  description = "The User Data"
}

variable "aws_default_sg" {
  description = "The AWS Default Security Group"
}

variable "aws_sg_names" {
  description = "The AWS Security Group names"
  type        = "list"
}

variable "aws_sg_ports" {
  description = "The AWS Securoty Group ports"
  type        = "list"
}

#variable "" {
#	description	= "The "
#}

