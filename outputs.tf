#output "Bastion Public IP" {
#  value =  ["${element(concat(module.ec2.test.*.public_ip, list("")), 0)}"]
#}

