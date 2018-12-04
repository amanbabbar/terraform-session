resource "aws_vpc" "main" {
    cidr_block       = "10.20.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "Terraform-session"
    }
}

resource "aws_subnet" "main-public-1" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "10.20.0.0/24"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true

    tags {
        Name = "terraform-subnet1"
    }
}

resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "vpc-ig"
    }
}

resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags {
        Name = "Terraform-session"
    }
}

resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}