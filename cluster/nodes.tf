resource "template_file" "cloud_config" {
  count = "${var.cluster_size}"
  template = "${file("${path.module}/templates/cloud-config.yml")}"

  vars {
    hostname = "coreos${count.index}"
    ca_cert = "${base64encode(var.ca_cert_pem)}"
    coreos_key = "${base64encode(element(tls_private_key.coreos.*.private_key_pem, count.index))}"
    coreos_cert = "${base64encode(element(tls_locally_signed_cert.coreos.*.cert_pem, count.index))}"
    region = "${var.region}"
    cluster_id = "${var.cluster_id}"
    dns_zone_name = "${var.private_dns_zone_name}"
  }
}

resource "aws_instance" "node" {
  count = "${var.cluster_size}"
  ami = "${var.coreos_ami}"
  instance_type = "${var.cluster_instance_type}"
  subnet_id = "${element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))}"
  private_ip = "${cidrhost(element(var.private_subnet_cidrs, count.index % length(var.private_subnet_cidrs)), 10 + (count.index / length(var.private_subnet_cidrs)))}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_security_group_ids = [
    "${var.default_security_group_id}",
    "${aws_security_group.node.id}",
    "${aws_security_group.etcd.id}",
  ]

  key_name = "${var.env}-deployer"

  tags = {
    OS = "coreos"
    Name = "${var.env}-${var.cluster_id}-node-${count.index}"
  }

  user_data = "${element(template_file.cloud_config.*.rendered, count.index)}"
}
