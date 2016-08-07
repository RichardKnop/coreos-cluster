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

variable "registry_id" {
  type        = "string"
  description = "Docker registry ID"
}

variable "registry_private_ip" {
  type        = "string"
  description = "Private IP address of the Docker registry"
}

variable "registry_user" {
  type        = "string"
  description = "Docker registry SSH user"
}

variable "private_dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "virtual_host" {
  type        = "string"
  description = "Virtual host used to route traffic from nginx proxy"
}

variable "git_repo" {
  type        = "string"
  description = "Git repository URL"
}

variable "git_dest" {
  type        = "string"
  description = "Directory where to store the repository"
}

variable "version" {
  type        = "string"
  description = "API version to deploy"
}

variable "etcd_path" {
  type        = "string"
  description = "Path to store the configuration"
}

variable "etcd_config" {
  type        = "string"
  description = "Configuration to store in ETCD (JSON string)"
}
