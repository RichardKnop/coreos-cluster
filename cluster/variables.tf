variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "region" {
  type        = "string"
  description = "AWS region"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "cluster_id" {
  type        = "string"
  description = "Unique name for the cluster"
}

variable "cluster_size" {
  type        = "string"
  description = "Cluster size (number of nodes)"
}

variable "cluster_instance_type" {
  type        = "string"
  description = "EC2 instance type to use for cluster nodes"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "coreos_ami" {
  type        = "string"
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group_id" {
  type        = "string"
  description = "Default security group ID"
}

variable "rds_user_security_group_id" {
  type        = "string"
  description = "RDS user security group ID"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "force_destroy" {
  type        = "string"
  description = "Delete S3 buckets content"
}
