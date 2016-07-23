resource "aws_route53_record" "registry_elb_alias" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.cluster_id}.${var.env}.registry.${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.registry.zone_id}"
    name = "${aws_elb.registry.dns_name}"
    evaluate_target_health = true
  }
}
