resource "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-config.yml")}"

  vars {
    private_key = "${base64encode(tls_private_key.registry.private_key_pem)}"
    certificate = "${base64encode(tls_self_signed_cert.registry.cert_pem)}"
    region = "${var.region}"
    storage_bucket = "${aws_s3_bucket.registry_storage.bucket}"
    host = "registry.${var.env}.${var.dns_zone_name}"
    port = "${var.port}"
  }
}

resource "aws_instance" "registry" {
  ami = "${var.coreos_ami}"
  instance_type = "${var.registry_instance_type}"
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
    Name = "${var.env}-registry"
  }

  user_data = "${template_file.cloud_config.rendered}"
}
