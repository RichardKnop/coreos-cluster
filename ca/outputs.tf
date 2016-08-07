output "ca_key_algorithm" {
  value = "${tls_private_key.ca.algorithm}"
}

output "ca_private_key_pem" {
  value = "${tls_private_key.ca.private_key_pem}"
}

output "ca_cert_pem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}
