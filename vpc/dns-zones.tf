resource "aws_route53_zone" "public" {
  name = "${var.dns_zone_name}"
  tags {
    Environment = "${var.env}-public-dns-zone"
  }
}

resource "aws_route53_record" "public" {
    zone_id = "${aws_route53_zone.public.zone_id}"
    name = "${aws_route53_zone.public.name}"
    type = "NS"
    ttl = "30"
    records = [
      "${aws_route53_zone.public.name_servers.0}",
      "${aws_route53_zone.public.name_servers.1}",
      "${aws_route53_zone.public.name_servers.2}",
      "${aws_route53_zone.public.name_servers.3}"
    ]
}

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
