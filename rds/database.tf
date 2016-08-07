resource "aws_db_instance" "default" {
  identifier = "${var.env}-${var.database_id}-database"
  name = "${var.db_name}"
  allocated_storage = "${var.rds_allocated_storage}"
  storage_type = "gp2"
  skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  engine = "postgres"
  engine_version = "${var.postgres_engine_version}"
  instance_class = "${var.rds_instance_type}"
  username = "${var.db_user}"
  password = "${var.db_password}"
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = true
  vpc_security_group_ids = [
    "${aws_security_group.rds.id}"
  ]

  db_subnet_group_name = "${var.env}-${var.database_id}-db-subnet-group"
  publicly_accessible = false
  backup_retention_period = 7
  depends_on = [
    "aws_db_subnet_group.default"
  ]
}

resource "aws_db_subnet_group" "default" {
  name = "${var.env}-${var.database_id}-db-subnet-group"
  description = "Subnets for the main database"
  subnet_ids = [
    "${var.private_subnet_ids}"
  ]
}
