resource "template_file" "registry_storage_bucket_policy" {
  template = "${file("${path.module}/templates/storage-bucket-policy.json")}"

  vars {
    env = "${var.env}"
    dns_zone_name = "${var.private_dns_zone_name}"
    registry_iam_role_arn = "${aws_iam_role.registry.arn}"
  }
}

resource "aws_s3_bucket" "registry_storage" {
  bucket = "registry.${var.env}.${var.private_dns_zone_name}"
  acl = "private"
  force_destroy = "${var.force_destroy}"
  policy = "${template_file.registry_storage_bucket_policy.rendered}"

  tags {
    Name = "S3 bucket to act as Docker registry storage"
    Environment = "${var.env}"
  }
}
