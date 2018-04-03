###################
# Security Group  #
###################
resource "aws_security_group" "security_group" {
  count = "${var.create_sg && length(var.aws_sg_ports) > 0 ? length(var.aws_sg_ports) : 0 }"

  name        = "default${element(var.aws_sg_names, count.index)}"
  description = "The default for ${element(var.aws_sg_names, count.index)}"
  vpc_id      = "${var.aws_vpc_id}"

  ingress {
    from_port   = "${element(var.aws_sg_ports, count.index)}"
    to_port     = "${element(var.aws_sg_ports, count.index)}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name        = "default${element(var.aws_sg_names, count.index)}"
    Description = "Security Group for ${element(var.aws_sg_names, count.index)}"
  }
}
