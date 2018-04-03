##########
# Docker #
# Master #
##########
resource "aws_instance" "master" {
  count         = "${var.create_cassandra ? 1 : 0 }"
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_instance_type}"

  vpc_security_group_ids = [
    "${var.aws_security_groups}",
  ]

  subnet_id = "${element(var.aws_private_subnets, count.index)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  connection {
    bastion_host        = "${var.aws_bastion_ip}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("${path.module}/files/deployer.pem")}"
    user                = "ec2-user"
    private_key         = "${file("${path.module}/files/deployer.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker mc",
      "sudo service docker start",
      "sudo docker swarm init",
      "sudo service docker start",
      "sudo docker swarm join-token --quiet worker > /home/ec2-user/token",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/files"
    destination = "/home/ec2-user/"
  }

  tags = {
    Name = "Docker swarm-master"
  }
}

##########
# Docker #
# Slave  #
##########
resource "aws_instance" "slave" {
  count         = "${var.create_cassandra && var.number_of_nodes > 0 ? var.number_of_nodes : 0 }"
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_instance_type}"

  vpc_security_group_ids = [
    "${var.aws_security_groups}",
  ]

  subnet_id = "${element(var.aws_private_subnets, count.index+1)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  connection {
    bastion_host        = "${var.aws_bastion_ip}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("${path.module}/files/deployer.pem")}"
    user                = "ec2-user"
    private_key         = "${file("${path.module}/files/deployer.pem")}"
  }

  provisioner "file" {
    source      = "${path.module}/files/deployer.pem"
    destination = "/home/ec2-user/deployer.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker mc",
      "sudo service docker start",
      "sudo service docker start",
      "sudo chmod 400 /home/ec2-user/deployer.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i deployer.pem ec2-user@${aws_instance.master.private_ip}:/home/ec2-user/token .",
      "sudo docker swarm join --token $(cat /home/ec2-user/token) ${aws_instance.master.private_ip}:2377",
    ]
  }

  tags = {
    Name = "Docker swarm node-${count.index+1}"
  }
}

resource "null_resource" "cluster" {
  count = "${var.create_cassandra ? 1 : 0 }"

  connection {
    bastion_host        = "${var.aws_bastion_ip}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("${path.module}/files/deployer.pem")}"
    host                = "${aws_instance.master.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("${path.module}/files/deployer.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker network create --driver overlay --scope swarm cassandra-net",
      "sudo docker node ls -q > IDs.txt",
      "sudo sh -c 'while read -d \" \" -u3 node; read -u4 id; do docker node update --label-add server=\"$node\" \"$id\"; done 3<<<$(echo \"master worker worker\") 4< IDs.txt'",
      "sudo docker pull cassandra",
      "sudo docker stack deploy --compose-file files/docker-compose.yml cassandra",
    ]
  }

  depends_on = ["aws_instance.slave"]
}
