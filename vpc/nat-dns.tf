resource "aws_route53_record" "nat" {
  zone_id = "${aws_route53_zone.public.id}"
  name = "${var.env}-nat.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.nat.public_ip}"]
}
