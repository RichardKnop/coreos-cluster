resource "aws_route53_record" "etcd_elb_alias" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-etcd.${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.etcd.zone_id}"
    name = "${aws_elb.etcd.dns_name}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "etcd_node_alias" {
  count = "${var.cluster_size}"
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-etcd${count.index}.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${element(aws_instance.node.*.private_ip, count.index)}"]
}

resource "aws_route53_record" "etcd_srv_server" {
  zone_id = "${var.dns_zone_id}"
  name = "_etcd-server._tcp.${var.dns_zone_name}"
  type = "SRV"
  ttl = "60"
  records = ["${formatlist("0 0 2380 %s", aws_route53_record.etcd_node_alias.*.name)}"]

  depends_on = ["aws_route53_record.etcd_node_alias"]
}

resource "aws_route53_record" "etcd_srv_client" {
  zone_id = "${var.dns_zone_id}"
  name = "_etcd-client._tcp.${var.dns_zone_name}"
  type = "SRV"
  ttl = "60"
  records = ["${formatlist("0 0 2379 %s", aws_route53_record.etcd_node_alias.*.name)}"]

  depends_on = ["aws_route53_record.etcd_node_alias"]
}
