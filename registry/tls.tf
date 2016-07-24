resource "tls_private_key" "registry" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_cert_request" "registry" {
  key_algorithm = "${tls_private_key.registry.algorithm}"
  private_key_pem = "${tls_private_key.registry.private_key_pem}"

  subject {
    common_name = "registry.${var.env}.${var.dns_zone_name}"
    organization = "Example, Ltd"
    country = "GB"
  }

  dns_names = ["registry.${var.env}.${var.dns_zone_name}"]
}

resource "tls_locally_signed_cert" "registry" {
  cert_request_pem = "${tls_cert_request.registry.cert_request_pem}"

  ca_key_algorithm = "${var.ca_key_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem = "${var.ca_cert_pem}"

  validity_period_hours = 43800

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}
