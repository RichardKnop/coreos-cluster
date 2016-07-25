resource "template_file" "cloud_config" {
  count = "${var.cluster_size}"
  template = "${file("${path.module}/templates/cloud-config.yml")}"

  vars {
    ca_cert = "${base64encode(var.ca_cert_pem)}"
    env = "${var.env}"
    region = "${var.region}"
    cluster_id = "${var.cluster_id}"
    dns_zone_name = "${var.dns_zone_name}"
    count_index = "${count.index}"
  }
}

resource "aws_instance" "node" {
  count = "${var.cluster_size}"
  ami = "${var.coreos_ami}"
  instance_type = "${var.cluster_instance_type}"
  subnet_id = "${element(var.private_subnets, count.index)}"

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
