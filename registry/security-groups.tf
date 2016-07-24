resource "aws_security_group" "registry_user" {
  name = "${var.env}-registry-user-sg"
  description = "Security group for instances that want to connect to registry"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-registry-user-sg"
  }
}

resource "aws_security_group" "registry" {
  name = "${var.env}-registry-sg"
  description = "Security group for registry nodes"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.registry_user.id}",
    ]
  }

  tags = {
    Name = "${var.env}-registry-sg"
  }
}
