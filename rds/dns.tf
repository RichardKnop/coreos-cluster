resource "aws_route53_record" "rds" {
   zone_id = "${var.dns_zone_id}"
   name = "${var.env}-rds.${var.dns_zone_name}"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_db_instance.main.address}"]
}
