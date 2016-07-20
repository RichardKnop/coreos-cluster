resource "aws_route53_record" "etcd" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-etcd.${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.etcd.zone_id}"
    name = "${aws_elb.etcd.dns_name}"
    evaluate_target_health = true
  }
}
