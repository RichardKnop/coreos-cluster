resource "template_file" "private_policy" {
  template = "${file("${path.module}/templates/private-policy.json")}"
}

resource "aws_vpc_endpoint" "private_s3" {
  vpc_id = "${var.vpc_id}"
  service_name = "com.amazonaws.${var.region}.s3"
  policy = "${template_file.private_policy.rendered}"
  route_table_ids = ["${var.private_route_table}"]
}
