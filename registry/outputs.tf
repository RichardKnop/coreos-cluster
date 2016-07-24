output "user_security_group_id" {
  value = "${aws_security_group.registry_user.id}"
}

output "host" {
  value = "${aws_route53_record.elb_alias.fqdn}"
}
