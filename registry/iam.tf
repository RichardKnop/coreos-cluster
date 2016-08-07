resource "template_file" "assume_role_policy" {
  template = "${file("${path.module}/templates/assume-role-policy.json")}"
}

resource "aws_iam_role" "registry" {
  name = "${var.env}-registry-iam-role"
  assume_role_policy = "${template_file.assume_role_policy.rendered}"
}

resource "template_file" "s3_policy" {
  template = "${file("${path.module}/templates/s3-policy.json")}"
}

resource "aws_iam_role_policy" "s3" {
  name = "${var.env}-registry-iam-role-s3-policy"
  role = "${aws_iam_role.registry.id}"
  policy = "${template_file.s3_policy.rendered}"
}

resource "aws_iam_instance_profile" "registry" {
  name = "${var.env}-registry-iam-profile"
  roles = ["${aws_iam_role.registry.name}"]
}
