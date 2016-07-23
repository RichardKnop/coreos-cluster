module "vpc" {
  source = "./vpc"

  env = "${var.env}"
  region = "${var.region}"
  nat_ami = "${lookup(var.nat_amis, var.region)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}

module "s3" {
  source = "./s3"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  private_route_table = "${module.vpc.private_route_table}"
}

module "rds" {
  source = "./rds"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  rds_instance_type = "${lookup(var.rds_instance_type, var.env)}"
  rds_allocated_storage = "${lookup(var.rds_allocated_storage, var.env)}"
  rds_skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  db_name = "${var.db_name}"
  db_user = "${var.db_user}"
  db_password = "${var.db_password}"
  dns_zone_id = "${module.vpc.private_dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}

module "cluster" {
  source = "./cluster"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  cluster_size = "${lookup(var.cluster_size, var.env)}"
  cluster_instance_type = "${lookup(var.cluster_instance_type, var.env)}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group_id = "${module.vpc.default_security_group_id}"
  rds_user_security_group_id = "${module.rds.user_security_group_id}"
  dns_zone_id = "${module.vpc.private_dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  force_destroy = "${var.force_destroy}"
}
