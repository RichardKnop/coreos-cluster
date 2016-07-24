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

variable "registry_user_security_group_id" {
  type        = "string"
  description = "Docker registry user security group ID"
}

variable "rds_user_security_group_id" {
  type        = "string"
  description = "RDS user security group ID"
}

variable "registry_host" {
  type        = "string"
  description = "DNS host of the private Docker registry"
}

variable "registry_port" {
  type        = "string"
  description = "Docker registry port"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "ca_key_algorithm" {
  type        = "string"
  description = "CA private key algorithm"
}

variable "ca_private_key_pem" {
  type        = "string"
  description = "CA private key in PEM format"
}

variable "ca_cert_pem" {
  type        = "string"
  description = "CA certificate in PEM format"
}

variable "force_destroy" {
  type        = "string"
  description = "Delete S3 buckets content"
}
