resource "aws_route53_record" "registry_alias" {
  zone_id = "${var.private_dns_zone_id}"
  name = "registry.${var.private_dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.registry.private_ip}"]
}
