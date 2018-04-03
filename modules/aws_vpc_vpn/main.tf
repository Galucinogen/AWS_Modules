#######
# AWS #
# VPN #
#######
resource "aws_customer_gateway" "main" {
  count      = "${var.create_vpn ? 1 : 0}"
  bgp_asn    = 65000
  ip_address = "${var.customer_vpn_ip}"
  type       = "ipsec.1"

  tags {
    Name = "CG to ${var.customer_name}"
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  count = "${var.create_vpn ? 1 : 0}"

  vpn_gateway_id      = "${var.vpn_gateway_id}"
  customer_gateway_id = "${aws_customer_gateway.main.id}"
  type                = "ipsec.1"

  static_routes_only = true

  tags = {
    Name = "VPN to ${var.customer_name}"
  }
}

resource "aws_vpn_connection_route" "vpn_routes" {
  count                  = "${var.create_vpn && length(var.customer_subnets) > 0 ? length(var.customer_subnets) : 0}"
  destination_cidr_block = "${element(var.customer_subnets, count.index)}"
  vpn_connection_id      = "${aws_vpn_connection.vpn_connection.id}"
}
