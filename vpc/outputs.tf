output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "private_dns_zone_id" {
  value = "${aws_route53_zone.private.id}"
}

output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_route_table" {
  value = "${aws_route_table.private.id}"
}

output "default_security_group" {
  value = "${aws_security_group.default.id}"
}

output "web_security_group" {
  value = "${aws_security_group.web.id}"
}

output "nat_public_ip" {
  value = "${aws_instance.nat.public_ip}"
}
