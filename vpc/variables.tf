variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "region" {
  type        = "string"
  description = "AWS region"
}

variable "nat_instance_type" {
  type        = "string"
  description = "EC2 instance type to use for NAT server"
}

variable "nat_ami" {
  type        = "string"
  description = "AMI for NAT server"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "vpc_cidr" {
  type        = "string"
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = "map"
  description = "AWS availability zones"

  default     = {
    zone0 = "eu-west-1a"
    zone1 = "eu-west-1b"
    zone2 = "eu-west-1c"
  }
}

variable "public_cidrs" {
  type        = "map"
  description = "CIDR for public subnet indexed by AZ"

  default     = {
    zone0 = "10.0.0.0/24"
    zone1 = "10.0.10.0/24"
    zone2 = "10.0.20.0/24"
  }
}

variable "private_cidrs" {
  type        = "map"
  description = "CIDR for private subnet indexed by AZ"

  default     = {
    zone0 = "10.0.1.0/24"
    zone1 = "10.0.11.0/24"
    zone2 = "10.0.21.0/24"
  }
}
