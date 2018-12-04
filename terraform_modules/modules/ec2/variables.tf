variable "tag_name" {}

variable "vpc_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "ubuntu_ami" {
  default = "ami-059eeca93cf09eebd"
}

variable "keypair_id" {}

variable "subnet_id" {}

