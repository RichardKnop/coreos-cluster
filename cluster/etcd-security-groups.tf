resource "aws_security_group" "etcd_user" {
  name = "${var.env}-etcd-user-sg"
  description = "Security group for instances that want to connect to ETCD"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-etcd-user-sg"
  }
}

resource "aws_security_group" "etcd_elb" {
  name = "${var.env}-etcd-elb-sg"
  description = "Security group for internal ELB to route client traffic to the ETCD cluster"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2379
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_user.id}",
    ]
  }

  tags = {
    Name = "${var.env}-etcd-elb-sg"
  }

  depends_on = ["aws_security_group.etcd_user"]
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "etcd_node" {
  name = "${var.env}-etcd-sg"
  description = "Security group for ETCD nodes that allows client traffic from the ELB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2379
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_elb.id}",
    ]
  }

  tags = {
    Name = "${var.env}-etcd-node-sg"
  }

  depends_on = ["aws_security_group.etcd_elb"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "etcd_cluster" {
  name = "${var.env}-etcd-cluster-sg"
  description = "Security group for ETCD cluster that allows peer traffic between nodes"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_node.id}",
    ]
  }

  egress {
    from_port       = 2379
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_node.id}",
    ]
  }

  tags = {
    Name = "${var.env}-etcd-cluster-sg"
  }

  depends_on = ["aws_security_group.etcd_node"]
  lifecycle {
    create_before_destroy = true
  }
}
