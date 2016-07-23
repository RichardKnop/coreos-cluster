variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "database_id" {
  type        = "string"
  description = "Unique name for the database"
}

variable "rds_instance_type" {
  type        = "string"
  description = "RDS instance type"
}

variable "rds_allocated_storage" {
  type        = "string"
  description = "RDS allocated storage"
}

variable "rds_skip_final_snapshot" {
  type        = "string"
  description = "Determines whether a final snapshot is created before the instance is deleted"
}

variable "postgres_engine_version" {
  type        = "string"
  description = "Version of Postgres we want to provision"
  default     = "9.5.2"
}

variable "db_password" {
  type        = "string"
  description = "Database password"
}

variable "db_name" {
  type        = "string"
  description = "Database name"
}

variable "db_user" {
  type        = "string"
  description = "Database username"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}
