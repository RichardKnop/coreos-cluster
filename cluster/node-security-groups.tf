resource "aws_security_group" "node" {
  name = "${var.env}-docker-node-sg"
  description = "Security group for Docker nodes"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-docker-node-sg"
  }
}
