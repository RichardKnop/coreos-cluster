resource "aws_security_group" "registry" {
  name = "${var.env}-registry-sg"
  description = "Security group for private Docker registry"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.node.id}",
    ]
  }

  egress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.node.id}",
    ]
  }

  tags = {
    Name = "${var.env}-registry-sg"
  }
}
