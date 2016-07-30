variable "env" {
  type        = "string"
  description = "Environment name"
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

variable "etcd_path" {
  type        = "string"
  description = "Path to store the configuration"
}

variable "etcd_config" {
  type        = "string"
  description = "Configuration to store in ETCD (JSON string)"
}

variable "public_subnet_ids" {
  type        = "string"
  description = "Public subnet IDs"
}

variable "web_security_group_id" {
  type        = "string"
  description = "Web security group ID"
}

variable "ssl_certificate_id" {
  type        = "string"
  description = "The id of an SSL certificate uploaded to AWS IAM"
}
