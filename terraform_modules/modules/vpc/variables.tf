variable "tag_name" {}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tenancy" {
  default = "default"
}

variable "vpc_id" {}

variable "subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  default = "10.0.4.0/24"
}

variable "private_subnet_cidr_2" {
  default = "10.0.5.0/24"
}

variable "region" {}
variable "route_table" {}
variable "subnet_id_1" {}

variable "main-gw" {
  default = ""
}

variable "create_subnet" {
  default = false
}

variable "create_private_subnet" {
  default = false
}

variable "create_ig" {
  default = false
}

variable "create_rtb" {
  default = false
}

variable "create_associations" {
  default = false
}


