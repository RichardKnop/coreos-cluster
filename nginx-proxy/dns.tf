resource "aws_route53_record" "nginx_proxy" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.dns_prefix}${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.nginx_proxy.dns_name}"]
}
