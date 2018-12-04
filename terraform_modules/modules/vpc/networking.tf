resource "aws_vpc" "main" {
    cidr_block       = "${var.vpc_cidr}"
    instance_tenancy = "${var.tenancy}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "${var.tag_name}"
    }
}

resource "aws_subnet" "main-public-1" {
    vpc_id     = "${var.vpc_id}"
    cidr_block = "${var.subnet_cidr_1}"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true
    tags {
        Name = "${var.tag_name}-subnet1"
    }
}

# resource "aws_subnet" "main-public-2" {
#     count      = "${var.create_subnet}"
#     vpc_id     = "${var.vpc_id}"
#     cidr_block = "${var.subnet_cidr_2}"
#     availability_zone = "${var.region}b"

#     tags {
#         Name = "${terraform.workspace}-main-public-2"
#     }
# }

resource "aws_subnet" "main-private-1" {
    count      = "${var.create_private_subnet}"
    vpc_id     = "${var.vpc_id}"
    cidr_block = "${var.private_subnet_cidr_1}"
    map_public_ip_on_launch = false
    availability_zone = "${var.region}a"

    tags {
        Name = "${var.tag_name}-private-subnet1"
    }
}
resource "aws_subnet" "main-private-2" {
    count      = "${var.create_private_subnet}"
    vpc_id     = "${var.vpc_id}"
    cidr_block = "${var.private_subnet_cidr_2}"
    map_public_ip_on_launch = false
    availability_zone = "${var.region}b"

    tags {
        Name = "${var.tag_name}-private-subnet2"
    }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    count = "${var.create_ig}"
    vpc_id = "${var.vpc_id}"

    tags {
        Name = "${var.tag_name}-ig"
    }
}

# route tables
resource "aws_route_table" "main-public" {
    count = "${var.create_rtb}"
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags {
        Name = "${var.tag_name}"
    }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
    count = "${var.create_associations}"
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "vpc_sg_id" {
  value = "${aws_vpc.main.default_security_group_id}"
}

output "route_table_id" {
  #value = "${var.create_associations ? aws_route_table.main-public.id : aws_vpc.main.main_route_table_id}"
  value = "${coalesce(join("", aws_route_table.main-public.*.id), join("", aws_vpc.main.*.main_route_table_id))}"
}

output "subnet_id_1" {
  value = [
    "${coalesce(join("", aws_subnet.main-public-1.*.id), join("", aws_subnet.main-public-1.*.id))}",
    "${coalesce(join("", aws_subnet.main-private-1.*.id), join("", aws_subnet.main-private-1.*.id))}",
    "${coalesce(join("", aws_subnet.main-private-2.*.id), join("", aws_subnet.main-private-2.*.id))}"
  ]
}



