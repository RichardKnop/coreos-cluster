resource "template_file" "assume_role_policy" {
  template = "${file("${path.module}/templates/assume-role-policy.json")}"
}

resource "aws_iam_role" "node" {
  name = "${var.env}-node-iam-role"
  assume_role_policy = "${template_file.assume_role_policy.rendered}"
}

resource "template_file" "elb_presence_policy" {
  template = "${file("${path.module}/templates/elb-presence-policy.json")}"
}

resource "aws_iam_role_policy" "elb_presence" {
  name = "${var.env}-node-iam-elb-presence-policy"
  role = "${aws_iam_role.node.id}"
  policy = "${template_file.elb_presence_policy.rendered}"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.env}-node-iam-profile"
  roles = ["${aws_iam_role.node.name}"]
}
