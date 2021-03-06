resource "aws_security_group" "node" {
  name = "${var.env}-${var.cluster_id}-node-sg"
  description = "Security group for cluster nodes"
  vpc_id = "${var.vpc_id}"

  # Open port 80 for load balancers
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [
      "${var.web_security_group_id}",
    ]
  }

  # Open port 443 for load balancers
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [
      "${var.web_security_group_id}",
    ]
  }

  tags = {
    Name = "${var.env}-${var.cluster_id}-node-sg"
  }
}

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
