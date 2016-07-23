output "user_security_group_id" {
  value = "${aws_security_group.rds_user.id}"
}
