resource "aws_elb" "api" {
  name = "${var.env}-api-elb"
  subnets = ["${var.public_subnet_ids}"]
  security_groups = [
    "${var.web_security_group_id}",
  ]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8080/v1/health"
    interval = 30
  }

  instances = ["${var.node_ids}"]
  cross_zone_load_balancing = true

  tags {
    Name = "${var.env}-api-elb"
  }
}
