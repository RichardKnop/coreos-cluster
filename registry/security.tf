resource "aws_security_group" "registry" {
  name = "${var.env}-registry-sg"
  description = "Security group for registry nodes"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.registry_port}"
    to_port         = "${var.registry_port}"
    protocol        = "tcp"
    security_groups = ["${var.user_security_group_ids}"]
  }

  tags = {
    Name = "${var.env}-registry-sg"
  }
}
