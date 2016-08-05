variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "nat_amis" {
  type        = "map"
  description = "AMIs for NAT server by region"

  default     = {
    eu-west-1 = "ami-d03288a3"
  }
}

variable "coreos_amis" {
  type        = "map"
  description = "CoreOS AMIs by region"

  default     = {
    eu-west-1 = "ami-cbb5d5b8"
  }
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "private_dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name for internal usage"
  default     = "local"
}

variable "nat_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for NAT server"

  default = {
    test  = "t2.micro"
    stage = "t2.micro"
    prod  = "t2.micro"
  }
}

variable "registry_instance_type" {
  type        = "map"
  description = "Docker registry instance type"

  default = {
    test  = "t2.small"
    stage = "t2.small"
    prod  = "t2.small"
  }
}

variable "rds_instance_type" {
  type        = "map"
  description = "RDS instance type"

  default = {
    test  = "db.t2.micro"
    stage = "db.t2.micro"
    prod  = "db.t2.micro"
  }
}

variable "rds_allocated_storage" {
  type        = "map"
  description = "RDS allocated storage"

  default = {
    test  = 10
    stage = 10
    prod  = 30
  }
}

variable "db_name" {
  type        = "string"
  description = "Database name"
}

variable "db_user" {
  type        = "string"
  description = "Database username"
}

variable "db_password" {
  type        = "string"
  description = "Database password"
}

variable "rds_skip_final_snapshot" {
  type        = "string"
  description = "Determines whether a final snapshot is created before the instance is deleted"
  default     = false
}

variable "cluster_size" {
  type        = "map"
  description = "Cluster size (number of nodes)"

  default = {
    test  = 2
    stage = 2
    prod  = 4
  }
}

variable "cluster_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for cluster nodes"

  default = {
    test  = "t2.small"
    stage = "t2.small"
    prod  = "t2.small"
  }
}

variable "force_destroy" {
  type        = "string"
  description = "Delete S3 buckets content"
  default     = false
}

variable "api_config" {
  type        = "string"
  description = "API JSON configuration to load into ETCD"
}

variable "api_dns_prefix" {
  type        = "string"
  description = "DNS prefix (e.g. stage-api. or api.)"
}

variable "ssl_certificate_body" {
  type        = "string"
  description = "The contents of the public key certificate in PEM-encoded format."
}

variable "ssl_certificate_chain" {
  type        = "string"
  description = "The contents of the certificate chain. This is typically a concatenation of the PEM-encoded public key certificates of the chain."
}

variable "ssl_certificate_private_key" {
  type        = "string"
  description = "The contents of the private key in PEM-encoded format."
}
