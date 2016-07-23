resource "aws_security_group" "node" {
  name = "${var.env}-${var.cluster_id}-node-sg"
  description = "Security group for cluster nodes"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-${var.cluster_id}-node-sg"
  }
}
