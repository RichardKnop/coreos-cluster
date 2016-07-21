variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "cluster_size" {
  type        = "string"
  description = "Cluster size (number of nodes)"
}

variable "node_instance_type" {
  type        = "string"
  description = "EC2 instance type to use for nodes"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "coreos_ami" {
  type        = "string"
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group" {
  type        = "string"
  description = "Default security group"
}

variable "rds_user_security_group" {
  type        = "string"
  description = "RDS user security group"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}
