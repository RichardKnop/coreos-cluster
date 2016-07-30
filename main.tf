module "ca" {
  source = "./ca"
}

module "vpc" {
  source = "./vpc"

  env = "${var.env}"
  region = "${var.region}"
  nat_instance_type = "${lookup(var.nat_instance_type, var.env)}"
  nat_ami = "${lookup(var.nat_amis, var.region)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  private_dns_zone_name = "${var.private_dns_zone_name}"
}

module "s3" {
  source = "./s3"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  private_route_table = "${module.vpc.private_route_table}"
}

module "cluster" {
  source = "./cluster"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  cluster_id = "cluster1"
  cluster_size = "${lookup(var.cluster_size, var.env)}"
  cluster_instance_type = "${lookup(var.cluster_instance_type, var.env)}"
  private_subnet_ids = "${split(",", module.vpc.private_subnet_ids)}"
  private_subnet_cidrs = "${split(",", module.vpc.private_subnet_cidrs)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group_id = "${module.vpc.default_security_group_id}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  private_dns_zone_id = "${module.vpc.private_dns_zone_id}"
  private_dns_zone_name = "${var.private_dns_zone_name}"
  ca_key_algorithm = "${module.ca.ca_key_algorithm}"
  ca_private_key_pem = "${module.ca.ca_private_key_pem}"
  ca_cert_pem = "${module.ca.ca_cert_pem}"
  force_destroy = "${var.force_destroy}"
}

module "registry" {
  source = "./registry"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  registry_instance_type = "${lookup(var.registry_instance_type, var.env)}"
  private_subnet_ids = "${split(",", module.vpc.private_subnet_ids)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group_id = "${module.vpc.default_security_group_id}"
  user_security_group_ids = "${split(",", module.cluster.node_security_group_id)}"
  private_dns_zone_id = "${module.vpc.private_dns_zone_id}"
  private_dns_zone_name = "${var.private_dns_zone_name}"
  ca_key_algorithm = "${module.ca.ca_key_algorithm}"
  ca_private_key_pem = "${module.ca.ca_private_key_pem}"
  ca_cert_pem = "${module.ca.ca_cert_pem}"
  force_destroy = "${var.force_destroy}"
}

module "rds" {
  source = "./rds"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  private_subnet_ids = "${split(",", module.vpc.private_subnet_ids)}"
  database_id = "database1"
  user_security_group_ids = "${split(",", module.cluster.node_security_group_id)}"
  rds_instance_type = "${lookup(var.rds_instance_type, var.env)}"
  rds_allocated_storage = "${lookup(var.rds_allocated_storage, var.env)}"
  rds_skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  db_name = "${var.db_name}"
  db_user = "${var.db_user}"
  db_password = "${var.db_password}"
  private_dns_zone_id = "${module.vpc.private_dns_zone_id}"
  private_dns_zone_name = "${var.private_dns_zone_name}"
}

module "api" {
  source = "./api"

  env = "${var.env}"
  bastion_host = "${module.vpc.nat_public_ip}"
  bastion_user = "ec2-user"
  node_ids = "${split(",", module.cluster.node_ids)}"
  node_private_ips = "${module.cluster.node_private_ips}"
  node_user = "core"
  registry_id = "${module.registry.registry_id}"
  registry_private_ip = "${module.registry.registry_private_ip}"
  registry_user = "core"
  etcd_path = "/config/example_api.json"
  etcd_config = "${var.api_config}"
  public_subnet_ids = "${split(",", module.vpc.public_subnet_ids)}"
  web_security_group_id = "${module.vpc.web_security_group_id}"
  ssl_certificate_id = "${var.ssl_certificate_id}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  dns_prefix = "${var.api_dns_prefix}"
}
