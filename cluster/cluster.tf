resource "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-config.yml")}"

  vars {
    etcd_discovery_url = "${var.discovery_url}"
  }
}

resource "aws_instance" "node" {
  count = "${var.cluster_size}"
  ami = "${var.coreos_ami}"
  instance_type = "${var.node_instance_type}"
  subnet_id = "${element(var.private_subnets, count.index)}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_security_group_ids = [
    "${var.default_security_group}",
    "${aws_security_group.etcd_cluster.id}",
    "${aws_security_group.etcd_node.id}",
    "${var.rds_user_security_group}",
  ]

  key_name = "${var.env}-deployer"

  tags = {
    OS = "${var.env}-coreos"
    Name = "${var.env}-etcd-${count.index}"
  }

  user_data = "${template_file.cloud_config.rendered}"
}
