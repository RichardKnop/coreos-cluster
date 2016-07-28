resource "template_file" "node_assume_role_policy" {
  template = "${file("${path.module}/templates/assume-role-policy.json")}"
}

resource "aws_iam_role" "node" {
  name = "${var.env}-node-iam-role"
  assume_role_policy = "${template_file.node_assume_role_policy.rendered}"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.env}-node-iam-profile"
  roles = ["${aws_iam_role.node.name}"]
}
