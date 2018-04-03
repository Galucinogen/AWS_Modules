#######
# RDS #
#######

resource "aws_db_instance" "default" {
  count = "${var.create_rds ? 1 : 0 }"

  identifier             = "${var.oracle_rds_identifier}"
  allocated_storage      = "10"
  engine                 = "${var.oracle_rds_engine}"
  engine_version         = "${var.oracle_rds_engine_version}"
  license_model          = "bring-your-own-license"
  instance_class         = "${var.oracle_rds_instance_class}"
  name                   = "${var.oracle_rds_name}"
  username               = "admin"
  password               = "adminadmin"
  vpc_security_group_ids = ["${aws_security_group.defaultRDS.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.dev-subnets.name}"
  skip_final_snapshot    = true
  apply_immediately      = false
}
