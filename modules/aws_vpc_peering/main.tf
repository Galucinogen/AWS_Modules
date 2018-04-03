###############
# AWS         #
# VPC Peering #
###############
resource "aws_vpc_peering_connection" "vpc_peer" {
  count         = "${var.create_vpc_peering ? 1 : 0 }"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${var.peer_account_id}"
  vpc_id        = "${var.owner_vpc_id}"
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags {
    Name    = "VPC Peering"
    Comment = "Managed By Terraform"
  }
}

resource "aws_route" "owner_to_peer_subnet_routes" {
  count                     = "${var.create_vpc_peering ? length(var.owner_route_table_ids) * length(var.peer_route_table_ids) : 0}"
  route_table_id            = "${element(var.owner_route_table_ids, count.index)}"
  destination_cidr_block    = "${element(var.peer_subnets, count.index)}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}

resource "aws_route" "peer_to_owner_subnet_routes" {
  count                     = "${var.create_vpc_peering ? length(var.owner_route_table_ids) * length(var.peer_route_table_ids) : 0}"
  route_table_id            = "${element(var.peer_route_table_ids, count.index)}"
  destination_cidr_block    = "${element(var.owner_subnets, count.index)}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}
