resource "aws_iam_server_certificate" "ssl_certificate" {
  name = "${var.env}-ssl-certificate"
  certificate_body = "${var.ssl_certificate_body}"
  certificate_chain = "${var.ssl_certificate_chain}"
  private_key = "${var.ssl_certificate_private_key}"
}
