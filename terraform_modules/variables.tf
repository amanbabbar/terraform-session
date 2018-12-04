variable "region" {
  type = "map"
  default = {
    "dev" = "us-west-2"
    "stag" = "us-east-2"
  }
}

variable "profile" {
  type = "map"
  default = {
    "dev" = "ghdev1"
    "stag" = "ghdev2"
  }
}

variable "assume_role_arn" {}

variable "ubuntu_ami" {
  type = "map"
  default = {
    "us-east-1" = "ami-059eeca93cf09eebd"
    "stag" = "ami-0782e9ee97725263d"
    "dev" = "ami-0e32ec5bc225539f5"
  }
}

variable "instance_type" {
  type = "map"
  default = {
    "dev" = "t2.micro"
    "stag" = "t2.medium"
  }
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "./loadServer.pub"
}

variable "db_azs" {
  type = "list"
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c",
  ]
}
variable "db_identifier" {
  default = "vend"
}
variable "allocated_storage" {
  default = "20"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.7.23"
}
variable "instance_class" {
  default = "db.t2.medium"
}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "multi_az" {
  default = false
}

variable "publicly_accessible" {
  default = true
}

variable "skip_final_snapshot" {
  default = true
}

