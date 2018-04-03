############
# Networks #
# VPC      #
############

resource "aws_vpc" "vpc" {
  count                = "${var.create_vpc ? 1 : 0 }"
  cidr_block           = "${var.aws_vpc_network}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.aws_vpc_name}"
  }
}

############
# Subnets  #
# Private  #
############

resource "aws_subnet" "aws_private_subnets" {
  count             = "${var.create_vpc && length(var.aws_private_subnets) > 0 ? length(var.aws_private_subnets) : 0}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.aws_private_subnets[count.index]}"
  availability_zone = "${var.aws_availability_zones[count.index]}"

  tags = {
    Name = "Private Subnet ${count.index+1}"
  }

  depends_on = ["aws_vpc.vpc"]
}

###########
# Public  #
###########

resource "aws_subnet" "aws_public_subnets" {
  count                   = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? length(var.aws_public_subnets) : 0}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_public_subnets[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_availability_zones[count.index]}"

  tags = {
    Name = "Public Subnet ${count.index+1}"
  }

  depends_on = ["aws_vpc.vpc"]
}

####################
# Internet Gateway #
####################

resource "aws_internet_gateway" "gw" {
  count  = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? 1 : 0 }"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "InternetGateway"
  }

  depends_on = ["aws_vpc.vpc"]
}

###############
# Nat Gateway #
# EIP         #
###############
resource "aws_eip" "nat_ip" {
  count      = "${var.create_vpc && var.enable_nat_gateway ? 1 : 0 }"
  vpc        = true
  depends_on = ["aws_vpc.vpc", "aws_internet_gateway.gw"]

  tags = {
    Name = "NAT EIP"
  }
}

################
# NAT Instance #
################
resource "aws_nat_gateway" "nat_gw" {
  count         = "${var.create_vpc && var.enable_nat_gateway ? 1 : 0 }"
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id     = "${element(aws_subnet.aws_public_subnets.*.id, count.index)}"

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = ["aws_internet_gateway.gw"]
}

################
# Route tables #
# Private      #
################

resource "aws_default_route_table" "private_route_table" {
  count                  = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? 1 : 0}"
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name = "Private route table"
  }

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_private_subnets"]
}

resource "aws_route" "private_routes" {
  count                  = "${var.create_vpc && length(var.aws_private_subnets) > 0 && var.enable_nat_gateway ? 1 : 0}"
  route_table_id         = "${aws_default_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_private_subnets"]
}

resource "aws_route_table_association" "private_association" {
  count          = "${var.create_vpc && length(var.aws_private_subnets) > 0 ? length(var.aws_private_subnets) : 0}"
  subnet_id      = "${element(aws_subnet.aws_private_subnets.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.private_route_table.id}"

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_private_subnets"]
}

##########
# Public #
##########

resource "aws_route_table" "public_route_table" {
  count  = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public route table"
  }

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_public_subnets"]
}

resource "aws_route" "public_routes" {
  count                  = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? 1 : 0}"
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_public_subnets"]
}

resource "aws_route_table_association" "public_association" {
  count          = "${var.create_vpc && length(var.aws_public_subnets) > 0 ? length(var.aws_public_subnets) : 0}"
  subnet_id      = "${element(aws_subnet.aws_public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"

  depends_on = ["aws_vpc.vpc", "aws_subnet.aws_public_subnets"]
}

###################
# Security Groups #
# Default         #
###################

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.aws_vpc_network}"]
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags {
    Name        = "default"
    Description = "Default Security Group"
  }

  depends_on = ["aws_vpc.vpc"]
}

################
# Network ACLs #
################

resource "aws_default_network_acl" "default" {
  count                  = "${var.create_vpc}"
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "Default ACL"
  }
}

##############
# VPN Gateway
##############
resource "aws_vpn_gateway" "vpn_gateway" {
  count  = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "The VPN Gateway"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_gateway_attachment" {
  count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

  vpc_id         = "${aws_vpc.vpc.id}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
}

resource "aws_vpn_gateway_route_propagation" "private_route_propagation" {
  count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

  route_table_id = "${element(aws_default_route_table.private_route_table.*.id, count.index)}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
}

resource "aws_vpn_gateway_route_propagation" "public_route_propagation" {
  count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

  route_table_id = "${element(aws_route_table.public_route_table.*.id, count.index)}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
}
