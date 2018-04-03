#################
# EC2 Instances #
# Test          #
#################
resource "aws_instance" "test" {
  count                       = "${var.create_ec2 && var.number_of_instances > 0 ? var.number_of_instances : 0 }"
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.aws_instance_type}"
  associate_public_ip_address = "true"

  subnet_id = "${var.aws_subnet}"

  key_name   = "${aws_key_pair.admin.key_name}"
  monitoring = "${var.ec2_monitoring}"

  #  vpc_security_group_ids = ["${var.aws_security_groups}"]

  vpc_security_group_ids = [
    "${var.aws_security_groups}",
    "${aws_security_group.security_group.*.id}",
  ]
  associate_public_ip_address = "true"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "12"
    delete_on_termination = true
  }

  #    lifecycle {
  #	create_before_destroy = true
  #    }

  user_data = "${var.user_data}"
  tags {
    Name = "Bastion Instance"
  }
  connection {
    user        = "ec2-user"
    private_key = "${file("${path.module}/files/deployer.pem")}"
  }
  provisioner "file" {
    source      = "${path.module}/files"
    destination = "/home/ec2-user/"
  }
  provisioner "remote-exec" {
    inline = [
      "eval $(ssh-agent -s)",
      "chmod 400 ~/files/deployer.pem",
      "ssh-add ~/files/deployer.pem",
    ]
  }
}

resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqwTjrOy/wo9GRd2AQznF0Zx1l99cdJIReJRvBlBWlnvHN1QJNNt0LAW5W+xVlZr4RQsaRLuIDhkorz9519Ye1CvcUaQY7hKz+7HC8SERmG8NclOkHC6z1wyk0edJgdoI5XdGQPYYZAQf3/NqbsPw6loKLw+HqRfA+wwJybd5p5wNBddFo0E+5jq32rdLfHrHdzDD5G93XYEQz0vGEgPTydCTQQyX/0BwbO8dZoONaloARKzE40rNDzF/x367DabYAwiq/4rKSCE1Uw/FQMrkOoq1UWPlXLKgAuHQxVoMV6f9r6+TFVGtmXlvBnOkO0jWU3xp9F4gFXi9lyOqM4VlF3ikIgqlmZ175ijLYDNt7S1DMSrk8FTUTk/HI8KDQImelQ23kcJIa/1DLl9ewn5ac4TGqSSThamM3H3lQucHALGqIIRx1DFyQWhmr/BBAmwHtY4BX+ExFpgfcCAJHPPVwvx5GNnDqlapQmfR+jFSyTN7L2vToalbsBFpcTZAUYNfmGlvGH64xrzLTX4ozAVpV0obermLp6Qgdi95asVyTc4MlyLhYK+0BWZWaLSoSzfnSv4d94BIOqpJ8cBpHeSt3N5SjgdgW6rlGRxXRgHUlKOjqdMz1AudVgmjaoyw0sA5jB8PB2ooml4nV0GAdQe7kWzWVUx4lXlo3b3zWyDU6/w== avgur@avgur.od.ua"
}
