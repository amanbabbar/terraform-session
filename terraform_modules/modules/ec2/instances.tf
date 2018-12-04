resource "aws_instance" "web" {
  instance_type = "${var.instance_type}"
  ami = "${var.ubuntu_ami}"

  key_name = "${var.keypair_id}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  associate_public_ip_address = true

  tags {
    Name = "${var.tag_name}"
  }
}

resource "aws_security_group" "allow-ssh" {
    vpc_id = "${var.vpc_id}"
    name = "allow-ssh"
    description = "security group that allows ssh and all egress traffic"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    tags {
        Name = "${terraform.workspace}-allow-ssh"
    }
}


output "instance_id" {
  value = "${aws_instance.web.id}"
}

output "subnet_id" {
  value = "${aws_instance.web.subnet_id}"
}

