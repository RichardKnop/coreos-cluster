resource "aws_route53_record" "api" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.dns_prefix}${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.api.zone_id}"
    name = "${aws_elb.api.dns_name}"
    evaluate_target_health = true
  }
}
