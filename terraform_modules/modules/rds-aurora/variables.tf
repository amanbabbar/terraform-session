variable "vpc_id" {}

variable "publicly_accessible" {
  default = false
}
variable "cluster_name" {
  default = "rds-cluster"
} 
  
variable "instance_class" {
  default = "db.t2.small"
}

variable "username" {}

variable "password" {}

variable "subnets" {
  type        = "list"
  default     = []
}

#variable "security_group_ids" {}
