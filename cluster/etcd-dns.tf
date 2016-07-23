resource "aws_route53_record" "etcd_node_alias" {
  count = "${var.cluster_size}"
  zone_id = "${var.dns_zone_id}"
  name = "etcd${count.index}.${var.cluster_id}.${var.env}.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${element(aws_instance.node.*.private_ip, count.index)}"]
}

resource "aws_route53_record" "etcd_srv_server" {
  zone_id = "${var.dns_zone_id}"
  name = "_etcd-server._tcp.${var.cluster_id}.${var.env}.${var.dns_zone_name}"
  type = "SRV"
  ttl = "60"
  records = ["${formatlist("0 0 2380 %s", aws_route53_record.etcd_node_alias.*.name)}"]
}

resource "aws_route53_record" "etcd_srv_client" {
  zone_id = "${var.dns_zone_id}"
  name = "_etcd-client._tcp.${var.cluster_id}.${var.env}.${var.dns_zone_name}"
  type = "SRV"
  ttl = "60"
  records = ["${formatlist("0 0 2379 %s", aws_route53_record.etcd_node_alias.*.name)}"]
}
