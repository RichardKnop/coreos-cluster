resource "aws_key_pair" "deployer" {
  key_name = "${var.env}-deployer-key"
  public_key = "${var.public_key}"
}
