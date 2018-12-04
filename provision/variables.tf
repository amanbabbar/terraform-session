variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "ubuntu_ami" {
  default = "ami-0f9cf087c1f27d9b1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "./loadServer.pub"
}

