resource "template_file" "api_unit" {
  template = "${file("${path.module}/templates/example-api.service")}"

  vars {
    private_dns_zone_name = "${var.private_dns_zone_name}"
  }
}
