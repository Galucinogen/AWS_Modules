################
# RDS Networks #
# DB Subnets   #
################

resource "aws_subnet" "aws_rds_subnets" {
  count                   = "${var.create_rds && length(var.aws_rds_subnets) > 0 ? length(var.aws_rds_subnets) : 0 }"
  vpc_id                  = "${var.aws_vpc_id}"
  cidr_block              = "${var.aws_rds_subnets[count.index]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_availability_zones[count.index]}"

  tags = {
    Name = "RDS Subnet ${count.index+1}"
  }
}

resource "aws_db_subnet_group" "dev-subnets" {
  name        = "dev-subnets"
  description = "Dev Subnets"
  subnet_ids  = ["${aws_subnet.aws_rds_subnets.*.id}"]
}

resource "aws_route_table" "rds_route_table" {
  vpc_id = "${var.aws_vpc_id}"

  tags {
    Name = "RDS route table"
  }
}

resource "aws_route_table_association" "rds_association" {
  count          = "${length(var.aws_rds_subnets)}"
  subnet_id      = "${element(aws_subnet.aws_rds_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.rds_route_table.id}"
}
