resource "aws_route53_zone" "private" {
  name = "${var.private_dns_zone_name}"
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Environment = "${var.env}-private-dns-zone"
  }
}

resource "aws_route53_record" "private-ns" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name = "${var.private_dns_zone_name}"
  type = "NS"
  ttl = "30"
  records = [
    "${aws_route53_zone.private.name_servers.0}",
    "${aws_route53_zone.private.name_servers.1}",
    "${aws_route53_zone.private.name_servers.2}",
    "${aws_route53_zone.private.name_servers.3}"
  ]
}
