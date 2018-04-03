output "Bastion_Public_IP" {
  value = "${element(split(",", join(",", aws_instance.test.*.public_ip)), 0)}"
}

#output "security_groups" {
#  value = "${aws_security_group.security_group.*.id}"
#}

