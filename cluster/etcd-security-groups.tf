resource "aws_security_group" "etcd" {
  name = "${var.env}-${var.cluster_id}-etcd-sg"
  description = "Security group for ETCD nodes that allows both client traffic and peer traffic between nodes"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.node.id}",
    ]
  }

  egress {
    from_port       = 2379
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.node.id}",
    ]
  }

  tags = {
    Name = "${var.env}-${var.cluster_id}-etcd-sg"
  }
}
