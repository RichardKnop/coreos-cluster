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

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "ssl_certificate_id" {
  type        = "string"
  description = "The id of an SSL certificate uploaded to AWS IAM"
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

variable "etcd_discovery_url" {
  type        = "string"
  description = "ETCD discovery URL"
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

variable "node_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for nodes"

  default = {
    test  = "t2.micro"
    stage = "t2.micro"
    prod  = "t2.micro"
  }
}
