resource "aws_security_group" "rds_user" {
  name = "${var.env}-${var.database_id}-rds-user-sg"
  description = "Security group for instances that want to connect to RDS"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-${var.database_id}-rds-user-sg"
  }
}

resource "aws_security_group" "rds" {
  name = "${var.env}-${var.database_id}-rds-sg"
  description = "Security group for RDS database that allows traffic from allowed sources"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.rds_user.id}",
    ]
  }

  tags = {
    Name = "${var.env}-${var.database_id}-rds-sg"
  }
}
