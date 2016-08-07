resource "aws_security_group" "rds" {
  name = "${var.env}-${var.database_id}-rds-sg"
  description = "Security group for RDS database that allows traffic from allowed sources"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.db_port}"
    to_port         = "${var.db_port}"
    protocol        = "tcp"
    security_groups = ["${var.user_security_group_ids}"]
  }

  tags = {
    Name = "${var.env}-${var.database_id}-rds-sg"
  }
}
