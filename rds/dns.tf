resource "aws_route53_record" "default" {
  zone_id = "${var.private_dns_zone_id}"
  name = "${var.database_id}.${var.private_dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_db_instance.default.address}"]
}
