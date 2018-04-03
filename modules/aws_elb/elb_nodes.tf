resource "aws_instance" "elb_nodes" {
  count = "${var.create_elb && var.create_elb_nodes ? var.number_of_nodes : 0 }"

  instance_type = "t2.micro"
  ami           = "${var.aws_ami}"

  key_name = "${aws_key_pair.elb_nodes_key.key_name}"

  vpc_security_group_ids = [
    "${var.aws_security_groups}",
    "${aws_security_group.defaultLBnodes.*.id}",
  ]

  subnet_id = "${element(var.aws_public_subnets, count.index)}"

  user_data = <<HEREDOC
    #!/bin/bash
    yum update -y
    yum install -y mc nginx
    service nginx restart
HEREDOC

  tags {
    Name = "elb-node-${count.index+1}"
  }
}

resource "aws_key_pair" "elb_nodes_key" {
  count      = "${var.create_elb ? 1 : 0}"
  key_name   = "elb-admin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqwTjrOy/wo9GRd2AQznF0Zx1l99cdJIReJRvBlBWlnvHN1QJNNt0LAW5W+xVlZr4RQsaRLuIDhkorz9519Ye1CvcUaQY7hKz+7HC8SERmG8NclOkHC6z1wyk0edJgdoI5XdGQPYYZAQf3/NqbsPw6loKLw+HqRfA+wwJybd5p5wNBddFo0E+5jq32rdLfHrHdzDD5G93XYEQz0vGEgPTydCTQQyX/0BwbO8dZoONaloARKzE40rNDzF/x367DabYAwiq/4rKSCE1Uw/FQMrkOoq1UWPlXLKgAuHQxVoMV6f9r6+TFVGtmXlvBnOkO0jWU3xp9F4gFXi9lyOqM4VlF3ikIgqlmZ175ijLYDNt7S1DMSrk8FTUTk/HI8KDQImelQ23kcJIa/1DLl9ewn5ac4TGqSSThamM3H3lQucHALGqIIRx1DFyQWhmr/BBAmwHtY4BX+ExFpgfcCAJHPPVwvx5GNnDqlapQmfR+jFSyTN7L2vToalbsBFpcTZAUYNfmGlvGH64xrzLTX4ozAVpV0obermLp6Qgdi95asVyTc4MlyLhYK+0BWZWaLSoSzfnSv4d94BIOqpJ8cBpHeSt3N5SjgdgW6rlGRxXRgHUlKOjqdMz1AudVgmjaoyw0sA5jB8PB2ooml4nV0GAdQe7kWzWVUx4lXlo3b3zWyDU6/w== avgur@avgur.od.ua"
}
