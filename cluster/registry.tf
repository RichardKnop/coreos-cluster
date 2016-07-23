resource "template_file" "registry_cloud_config" {
  template = "${file("${path.module}/templates/registry-cloud-config.yml")}"

  vars {
    region = "${var.region}"
    storage_bucket = "${aws_s3_bucket.registry_storage.bucket}"
  }
}

resource "aws_instance" "registry" {
  ami = "${var.coreos_ami}"
  instance_type = "t2.micro"
  subnet_id = "${element(var.private_subnets, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.registry.name}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_security_group_ids = [
    "${var.default_security_group_id}",
    "${aws_security_group.registry.id}",
  ]

  key_name = "${var.env}-deployer"

  tags = {
    OS = "coreos"
    Name = "${var.env}-${var.cluster_id}-registry"
  }

  user_data = "${template_file.registry_cloud_config.rendered}"
}
