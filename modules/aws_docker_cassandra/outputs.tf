output "master.ip" {
  #  value = "${aws_instance.master.*.private_ip}"
  value = ["${element(concat(aws_instance.master.*.private_ip, list("")), 0)}"]

  #  value = "${element(split(",", join(",", aws_default_security_group.default.*.id)), 0)}"
}
