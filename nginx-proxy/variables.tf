variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "cluster_size" {
  type        = "string"
  description = "Cluster size (number of nodes)"
}

variable "bastion_host" {
  type        = "string"
  description = "Bastion host to run remote-exec provisioners"
}

variable "bastion_user" {
  type        = "string"
  description = "Bastion server SSH user"
}

variable "node_ids" {
  type        = "string"
  description = "Node IDs"
}

variable "node_private_ips" {
  type        = "string"
  description = "Private IP addresses of nodes"
}

variable "node_user" {
  type        = "string"
  description = "Node SSH user"
}

variable "public_subnet_ids" {
  type        = "string"
  description = "Public subnet IDs"
}

variable "web_security_group_id" {
  type        = "string"
  description = "Web security group ID"
}

variable "ssl_certificate_arn" {
  type        = "string"
  description = "The ARN of an AMI SSL certificate"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "dns_prefix" {
  type        = "string"
  description = "DNS prefix (e.g. stage-api. or api.)"
}

variable "private_dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}
