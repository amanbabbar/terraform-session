# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "web" {
    ami = "${var.ubuntu_ami}"
    instance_type = "${var.instance_type}"

    key_name = "terraform-session"
    vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
    associate_public_ip_address = true

    tags {
        Name = "Web Server"
    }
    provisioner "local-exec" {
        command = "echo ${aws_instance.web.public_ip} > instance_ip.txt"
    }
}
resource "null_resource" "example_provisioner" {
  triggers {
    public_ip = "${aws_instance.web.public_ip}"
  }

  connection {
    type = "ssh"
    host = "${aws_instance.web.public_ip}"
    user = "ubuntu"
    agent = false
    private_key = "${file("./terraform-session.pem")}"
  }

  // copy our example script to the server
  provisioner "file" {
    source      = "files/get-public-ip.sh"
    destination = "/tmp/get-public-ip.sh"
  }

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/get-public-ip.sh",
      "/tmp/get-public-ip.sh > /tmp/public-ip",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > file.txt"
  }

}
output "instance_id" {
  value = "${aws_instance.web.id}"
}
output "public_ip" {
  value = "${aws_instance.web.public_ip}"
}
