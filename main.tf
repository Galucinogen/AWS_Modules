############
# Provider #
#   AWS    #
############
provider "aws" {
  region                  = "eu-west-2"
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "default"
}

########
# VPC  #
# PROD #
########
module "aws_vpc_prod" {
  source = "modules/aws_vpc"

  create_vpc             = true
  enable_nat_gateway     = true
  enable_vpn_gateway     = true

  aws_vpc_name           = "DEV1"
  aws_vpc_network        = "172.16.0.0/16"

  aws_private_subnets    = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  aws_public_subnets     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

#######
# VPC #
# DEV #
#######
module "aws_vpc_dev" {
  source = "modules/aws_vpc"

  create_vpc         = true
  enable_nat_gateway = true
  enable_vpn_gateway = false

  aws_vpc_name    = "DEV2"
  aws_vpc_network = "173.16.0.0/16"

  aws_private_subnets    = ["173.16.1.0/24", "173.16.2.0/24", "173.16.3.0/24"]
  aws_public_subnets     = ["173.16.4.0/24", "173.16.5.0/24", "173.16.6.0/24"]
  aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

###########
# VPC     #
# Peering #
###########
module "aws_vpc_peering" {
  source = "modules/aws_vpc_peering"

  create_vpc_peering = true

  peer_account_id = ""

  owner_route_table_ids = ["${module.aws_vpc_prod.aws_private_route_table_ids}"]
  owner_subnet_ids      = ["${module.aws_vpc_prod.aws_private_subnet_ids}"]
  owner_subnets         = ["${module.aws_vpc_prod.aws_private_subnets}"]
  owner_vpc_id          = "${module.aws_vpc_prod.aws_vpc_id}"

  peer_route_table_ids = ["${module.aws_vpc_dev.aws_private_route_table_ids}"]
  peer_subnet_ids      = ["${module.aws_vpc_dev.aws_private_subnet_ids}"]
  peer_subnets         = ["${module.aws_vpc_dev.aws_private_subnets}"]
  peer_vpc_id          = "${module.aws_vpc_dev.aws_vpc_id}"
}

#######
# VPC #
# VPN #
#######
module "aws_vpc_vpn" {
  source = "modules/aws_vpc_vpn"

  create_vpn = false

  aws_vpc_id       = "${module.aws_vpc_prod.aws_vpc_id}"
  vpc_subnet_ids   = ["${module.aws_vpc_prod.aws_private_subnet_ids}", "${module.aws_vpc_prod.aws_public_subnet_ids}"]
  vpn_gateway_id   = "${module.aws_vpc_prod.aws_vpn_gateway_id}"
  customer_name    = "Office"
  customer_vpn_ip  = "1.1.1.1"
  customer_subnets = ["192.168.10.0/24"]
}

#######
# AWS #
# SES #
#######
module "aws_ses" {
  source = "modules/aws_ses"

  create_ses  = false
  create_dkim = false
  domain      = "test.com"
}

#############
# AWS       #
# S3 Busket #
#############
module "aws_s3_bucket" {
  source = "modules/aws_s3_bucket"

  create_s3_bucket = false

  #  s3_allow_public   = true
  bucket_name       = ["test"]
  acl_name          = "private"
  enable_versioning = true
}

###########
# AWS     #
# Bastion #
###########
module "aws_bastion_prod" {
  source = "modules/aws_bastion"

  create_bastion = false
  create_sg      = false

  number_of_instances = "1"
  aws_ami             = "ami-dff017b8"

  aws_instance_type = "t2.micro"
  ec2_monitoring    = false

  aws_sg_names = ["SSH"]
  aws_sg_ports = ["22"]

  aws_vpc_id      = "${module.aws_vpc_prod.aws_vpc_id}"
  aws_vpc_network = "${module.aws_vpc_prod.aws_vpc_network}"
  aws_subnet      = "${module.aws_vpc_prod.aws_public_subnet_id_1}"
  aws_default_sg  = "${module.aws_vpc_prod.aws_default_sg_id}"

  aws_security_groups = [
    "${module.aws_vpc_prod.aws_default_sg_id}",
  ]

  user_data = <<HEREDOC
    #!/bin/bash
    yum update -y
    yum install -y mc
HEREDOC

  tags {
    Name = "Bastion"
  }
}

################
# AWS          #
# Docker       #
# Cassandra    #
################
module "aws_docker_cassandra" {
  source = "modules/aws_docker_cassandra"

  create_cassandra = false

  number_of_nodes = "2"
  aws_ami         = "ami-dff017b8"

  aws_instance_type = "t2.micro"
  ec2_monitoring    = false

  aws_vpc_id      = "${module.aws_vpc_prod.aws_vpc_id}"
  aws_vpc_network = "${module.aws_vpc_prod.aws_vpc_network}"
  aws_bastion_ip  = "${module.aws_bastion_prod.Bastion_Public_IP}"

  aws_security_groups = [
    "${module.aws_vpc_prod.aws_default_sg_id}",
  ]

  aws_private_subnets = [
    "${module.aws_vpc_prod.aws_private_subnet_id_0}",
    "${module.aws_vpc_prod.aws_private_subnet_id_1}",
    "${module.aws_vpc_prod.aws_private_subnet_id_2}",
  ]

  aws_availability_zones = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]

  tags {
    Name = "Test EC2 Instance"
  }
}

################
# AWS          #
# K8s Cluster  #
################
module "aws_k8s" {
  source = "modules/aws_k8s"

  create_k8s_cluster    = true

  k8s_master_num        = "2"
  k8s_master_size       = "t2.medium"

  etcd_num              = "2"
  etcd_size             = "t2.medium"

  k8s_worker_num        = "4"
  k8s_kube_worker_size  = "t2.medium"

  k8s_cni               = "flannel"

}