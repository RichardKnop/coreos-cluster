output "registry_id" {
  value = "${aws_instance.registry.id}"
}

output "registry_private_ip" {
  value = "${aws_instance.registry.private_ip}"
}
