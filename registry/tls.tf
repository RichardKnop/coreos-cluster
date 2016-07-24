resource "tls_private_key" "registry" {
  algorithm = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "registry" {
  key_algorithm = "${tls_private_key.registry.algorithm}"
  private_key_pem = "${tls_private_key.registry.private_key_pem}"

  subject {
    common_name = "registry.${var.env}.${var.dns_zone_name}"
    organization = "Example, Ltd"
  }

  validity_period_hours = 43800

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
