output "node_security_group_id" {
  value = "${aws_security_group.node.id}"
}

output "node_ids" {
  value = "${join(",", aws_instance.node.*.id)}"
}

output "node_private_ips" {
  value = "${join(",", aws_instance.node.*.private_ip)}"
}
