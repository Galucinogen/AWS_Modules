#########################
# Elastic Load Balancer #
# Test                  #
#########################

resource "aws_elb" "web_lb" {
  count = "${var.create_elb ? 1 : 0}"

  name = "web-elb"

  subnets         = ["${var.aws_public_subnet_1}", "${var.aws_public_subnet_2}"]
  security_groups = ["${aws_security_group.defaultLB.id}"]

  listener = [
    {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    },
  ]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.elb_nodes.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  count                    = "${var.create_elb ? 1 : 0}"
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.web_lb.id}"
  lb_port                  = 80
  cookie_expiration_period = 600

  depends_on = ["aws_elb.web_lb"]
}
