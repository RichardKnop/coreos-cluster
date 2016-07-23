resource "aws_elb" "registry" {
  name = "${var.env}-${var.cluster_id}-registry-elb"
  subnets = ["${var.private_subnets}"]
  internal = true
  security_groups = [
    "${aws_security_group.registry_elb.id}",
  ]

  listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 5000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:5000/debug/health"
    interval = 30
  }

  instances = ["${aws_instance.registry.id}"]

  tags {
    Name = "${var.env}-${var.cluster_id}-registry-elb"
  }
}
