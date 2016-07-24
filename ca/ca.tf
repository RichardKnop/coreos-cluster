resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name = "CA"
    organization = "CA"
    country = "GB"
  }

  validity_period_hours = 43800
  is_ca_certificate = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}
