# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}
resource "aws_instance" "web" {
    ami = "${var.ubuntu_ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.main-public-1.id}"
    vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
    associate_public_ip_address = true

    tags {
        Name = "Web Server"
    }
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "instance_id" {
  value = "${aws_instance.web.id}"
}
output "public_ip" {
  value = "${aws_instance.web.public_ip}"
}
