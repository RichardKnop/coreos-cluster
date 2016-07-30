resource "tls_private_key" "coreos" {
  count = "${var.cluster_size}"
  algorithm = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "coreos" {
  count = "${var.cluster_size}"
  key_algorithm = "${element(tls_private_key.coreos.*.algorithm, count.index)}"
  private_key_pem = "${element(tls_private_key.coreos.*.private_key_pem, count.index)}"

  subject {
    common_name = "coreos${count.index}"
    organization = "Example, Ltd"
    country = "GB"
  }

  dns_names = [
    # private IP
    "${cidrhost(element(var.private_subnet_cidrs, count.index % length(var.private_subnet_cidrs)), 10 + (count.index / length(var.private_subnet_cidrs)))}",
    # private DNS alias
    "coreos${count.index}.${var.cluster_id}.${var.private_dns_zone_name}",
    # hostname
    "coreos${count.index}",
    # Docker bridge IP
    "172.17.0.1",
  ]
}

resource "tls_locally_signed_cert" "coreos" {
  count = "${var.cluster_size}"
  cert_request_pem = "${element(tls_cert_request.coreos.*.cert_request_pem, count.index)}"

  ca_key_algorithm = "${var.ca_key_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem = "${var.ca_cert_pem}"

  validity_period_hours = 43800

  allowed_uses = [
    "signing",
    "key encipherment",
    "server auth",
    "client auth",
  ]
}
