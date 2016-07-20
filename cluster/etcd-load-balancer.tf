resource "aws_elb" "etcd" {
  name = "${var.env}-etcd-elb"
  subnets = ["${var.private_subnets}"]
  internal = true
  security_groups = [
    "${aws_security_group.etcd_elb.id}",
  ]

  listener {
    instance_port = 2379
    instance_protocol = "http"
    lb_port = 2379
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:2379/health"
    interval = 30
  }

  instances = ["${aws_instance.node.*.id}"]

  tags {
    Name = "${var.env}-etcd-elb"
  }
}
