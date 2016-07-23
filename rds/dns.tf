resource "aws_route53_record" "default" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-${var.database_id}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_db_instance.default.address}"]
}
