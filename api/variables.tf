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
