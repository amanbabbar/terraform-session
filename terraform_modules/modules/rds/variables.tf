
variable "identifier" {}

variable "ec2_subnet_id" {}
variable "allocated_storage" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

#variable "name" {}

variable "username" {}

variable "password" {}

variable "multi_az" {
  default = false
}

variable "publicly_accessible" {
  default = false
}

variable "skip_final_snapshot" {
  default = true
}

#variable "vpc_security_group_ids" {}

variable "vpc_id" {}


variable "db_subnet_group_name" {}

variable "depends_on" {
  type = "list"
  default = []
}




