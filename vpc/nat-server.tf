resource "aws_instance" "nat" {
  ami = "${var.nat_ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.0.id}"
  source_dest_check = false

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_security_group_ids = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.nat_route.id}"
  ]

  key_name = "${var.env}-deployer"
  connection {
    user = "ec2-user"
    key_file = "~/.ssh/${var.env}-deployer"
  }

  tags = {
    OS = "${var.env}-amazon-linux"
    Name = "${var.env}-nat"
  }
}

resource "aws_security_group" "nat" {
  name = "${var.env}-nat-sg"
  description = "Security group for NAT instances that allows SSH from whitelisted IPs from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-nat-sg"
  }
}

resource "aws_security_group" "nat_route" {
  name = "${var.env}-nat-route-sg"
  description = "Security group for NAT instances that allows routing VPC traffic to internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      "${aws_security_group.default.id}"
    ]
  }

  tags {
    Name = "${var.env}-nat-route-sg"
  }
}
