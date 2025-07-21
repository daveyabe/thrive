variable "aws_region" {
  type        = string
  description = "AWS region to use for resources."
  default     = "us-east-2"
}

variable "secret_key" {
  type        = string
  description = "aws"
  nullable    = false
}

variable "aws_azs" {
  type        = list(string)
  description = "AWS Availability Zones"
  default     = ["us-east-2a"]
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Public Subnets in VPC"
  default     = ["10.0.201.0/24"]
}

#variable "instance_type" {
#  type        = string
#  description = "Type for EC2 Instance"
#  default     = "c5.large"
#}

variable "sg_ingress_public" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [
    {
      description = "Allows SSH access"
      port        = 22
    },
    {
      description = "Allows HTTP traffic"
      port        = 80
    },
  ]
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "DASH-ProjectThrive"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources."
  default     = "DashDemo"
}

variable "environment" {
  type        = string
  description = "Environment for deployment"
  default     = "DEV"
}

#variable "instance_key" {
#  default = "WorkshopKeyPair"
#}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
}
