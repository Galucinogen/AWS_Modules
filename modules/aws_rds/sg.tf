###############
# Default RDS #
###############
resource "aws_security_group" "defaultRDS" {
  count = "${var.create_rds && length(var.aws_rds_sg_ports) > 0 ? length(var.aws_rds_sg_ports) : 0 }"

  name        = "defaultRDS"
  description = "The default for RDS"
  vpc_id      = "${var.aws_vpc_id}"

  ingress {
    from_port   = "${element(var.aws_rds_sg_ports, count.index)}"
    to_port     = "${element(var.aws_rds_sg_ports, count.index)}"
    protocol    = "TCP"
    cidr_blocks = ["${var.aws_vpc_network}"]
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.aws_vpc_network}"]
    self        = true
  }

  tags {
    Name        = "defaultRDS"
    Description = "Security Group for RDS"
  }
}
