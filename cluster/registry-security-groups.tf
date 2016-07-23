resource "aws_security_group" "registry_elb" {
  name = "${var.env}-${var.cluster_id}-registry-elb-sg"
  description = "Security group for ELB in front of the registry"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.node.id}",
    ]
  }

  tags = {
    Name = "${var.env}-${var.cluster_id}-registry-elb-sg"
  }
}

resource "aws_security_group" "registry" {
  name = "${var.env}-${var.cluster_id}-registry-sg"
  description = "Security group for registry nodes"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.registry_elb.id}",
    ]
  }

  tags = {
    Name = "${var.env}-${var.cluster_id}-registry-sg"
  }
}
