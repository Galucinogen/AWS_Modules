output "aws_vpc_id" {
  value = "${element(split(",", join(",", aws_vpc.vpc.*.id)), 0)}"
}

output "aws_vpc_network" {
  value = "${element(split(",", join(",", aws_vpc.vpc.*.cidr_block)), 0)}"
}

output "aws_default_sg_id" {
  value = "${element(split(",", join(",", aws_default_security_group.default.*.id)), 0)}"
}

output "aws_public_subnet_id_1" {
  value = "${element(aws_subnet.aws_public_subnets.*.id, 0)}"
}

output "aws_public_subnet_id_2" {
  value = "${element(aws_subnet.aws_public_subnets.*.id, 1)}"
}

output "aws_private_subnet_id_0" {
  value = "${element(aws_subnet.aws_private_subnets.*.id, 0)}"
}

output "aws_private_subnet_id_1" {
  value = "${element(aws_subnet.aws_private_subnets.*.id, 1)}"
}

output "aws_private_subnet_id_2" {
  value = "${element(aws_subnet.aws_private_subnets.*.id, 2)}"
}

output "aws_private_subnet_ids" {
  value = "${element(split(",", join(",", aws_subnet.aws_private_subnets.*.id)), 0)}"
}

output "aws_public_subnet_ids" {
  value = "${element(split(",", join(",", aws_subnet.aws_public_subnets.*.id)), 0)}"
}

output "aws_private_route_table_ids" {
  value = "${aws_default_route_table.private_route_table.*.id}"
}

output "aws_private_subnets" {
  value = "${aws_subnet.aws_private_subnets.*.cidr_block}"
}

output "aws_vpn_gateway_id" {
  value = "${element(split(",", join(",", aws_vpn_gateway.vpn_gateway.*.id)), 0)}"
}
