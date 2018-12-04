provider "aws" {
  region = "${lookup(var.region, terraform.workspace)}"
  profile = "${lookup(var.profile, terraform.workspace)}"
  assume_role {
    role_arn     = "${terraform.workspace == "dev"? "arn:aws:iam::075784049186:role/GH-Dev1" : var.assume_role_arn}"
    session_name = "terraform-gh1"
  }
}

module "my_vpc" {
  source      = "../modules/vpc"
  tag_name    = "${terraform.workspace}-vpc1"
  vpc_cidr    = "10.0.0.0/16"
  tenancy     = "default"
  vpc_id      = "${module.my_vpc.vpc_id}"
  subnet_cidr_1 = "10.0.1.0/24"
  private_subnet_cidr_1 = "10.0.2.0/24"
  private_subnet_cidr_2 = "10.0.3.0/24"
  region        = "${lookup(var.region, terraform.workspace)}"
  subnet_id_1 = ""
  route_table = ""
  create_subnet = false
  create_private_subnet = true
  create_ig = true
  create_rtb = true
  create_associations = true
}

module "my_vpc2" {
  source      = "../modules/vpc"
  tag_name    = "${terraform.workspace}-vpc2"
  vpc_cidr    = "20.0.0.0/16"
  tenancy     = "default"
  vpc_id      = "${module.my_vpc2.vpc_id}"
  subnet_cidr_1 = "20.0.1.0/24"
  private_subnet_cidr_1 = ""
  private_subnet_cidr_2 = ""
  region        = "${lookup(var.region, terraform.workspace)}"
  subnet_id_1 = ""
  route_table = ""
  create_subnet = false
  create_private_subnet = false
  create_ig = true
  create_rtb = true
  create_associations = true
}

# module "my_vpc3" {
#   source      = "../modules/vpc"
#   tag_name    = "${terraform.workspace}-vpc3"
#   vpc_cidr    = "172.16.0.0/16"
#   tenancy     = "default"
#   vpc_id      = "${module.my_vpc3.vpc_id}"
#   subnet_cidr_1 = "172.16.1.0/24"
#   private_subnet_cidr_1 = ""
#   private_subnet_cidr_2 = ""
#   region        = "${lookup(var.region, terraform.workspace)}"
#   subnet_id_1 = ""
#   route_table = ""
#   create_subnet = false
#   create_private_subnet = false
#   create_ig = true
#   create_rtb = true
#   create_associations = true
# }
resource "aws_key_pair" "default" {
  key_name = "${terraform.workspace}-keypair"
  public_key = "${file("${var.key_path}")}"
}

module "my_ec2" {
  source = "../modules/ec2"

  vpc_id = "${module.my_vpc.vpc_id}"
  tag_name = "${terraform.workspace}-server1"
  instance_type = "${lookup(var.instance_type, terraform.workspace)}"
  ubuntu_ami = "${lookup(var.ubuntu_ami, terraform.workspace)}"
  keypair_id = "${aws_key_pair.default.id}"
  subnet_id = "${module.my_vpc.subnet_id_1[0]}"
}

module "my_ec2_2" {
  source = "../modules/ec2"

  vpc_id = "${module.my_vpc2.vpc_id}"
  tag_name = "${terraform.workspace}-server2"
  instance_type = "${lookup(var.instance_type, terraform.workspace)}"
  ubuntu_ami = "${lookup(var.ubuntu_ami, terraform.workspace)}"
  keypair_id = "${aws_key_pair.default.id}"
  subnet_id = "${module.my_vpc2.subnet_id_1[0]}"
}

# module "my_ec2_3" {
#   source = "../modules/ec2"

#   vpc_id = "${module.my_vpc3.vpc_id}"
#   tag_name = "${terraform.workspace}-server3"
#   instance_type = "${lookup(var.instance_type, terraform.workspace)}"
#   ubuntu_ami = "${lookup(var.ubuntu_ami, terraform.workspace)}"
#   keypair_id = "${aws_key_pair.default.id}"
#   subnet_id = "${module.my_vpc3.subnet_id_1[0]}"
# }

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "${terraform.workspace}_main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids = ["${module.my_vpc.subnet_id_1[1]}","${module.my_vpc.subnet_id_1[2]}"]
}

# module "aurora_mysql" {
#   source      = "../modules/rds-aurora"

#   vpc_id              = "${module.my_vpc.vpc_id}"
#   publicly_accessible = true
#   instance_class      = "db.t2.medium"
#   username            = "${var.db_username}"
#   password            = "${var.db_password}"
#   subnets             = ["${module.my_vpc.subnet_id_1[1]}","${module.my_vpc.subnet_id_1[2]}"]
#   #subnets   = "${aws_db_subnet_group.rds-subnet.id}"
#   security_group_ids = "${module.my_vpc.vpc_rds_sg_id}"
# }

module "db_instance" {
  source            = "../modules/rds"
  vpc_id            = "${module.my_vpc.vpc_id}"
  identifier        = "${terraform.workspace}-${var.db_identifier}"
  allocated_storage = "${var.allocated_storage}"
  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"

  #name              = "${var.db_name}"
  username          = "${var.db_username}"
  password          = "${var.db_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds-subnet.id}"
  multi_az            = "${var.multi_az}"
  publicly_accessible = "${var.publicly_accessible}"
  skip_final_snapshot = "${var.skip_final_snapshot}"
  ec2_subnet_id       = "${module.my_ec2.subnet_id}"
}

# resource "aws_vpc_peering_connection" "vpc_peering" {
#   peer_vpc_id   = "${module.my_vpc2.vpc_id}"
#   vpc_id        = "${module.my_vpc.vpc_id}"
#   auto_accept   = true

#   tags {
#     Name = "${terraform.workspace} - VPC Peering"
#   }
# }

# resource "aws_route" "route-a" {
#   route_table_id            = "${module.my_vpc.route_table_id}"
#   destination_cidr_block    = "${module.my_vpc2.vpc_cidr_block}"
#   vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
# }

# resource "aws_route" "route-b" {
#   route_table_id            = "${module.my_vpc2.route_table_id}"
#   destination_cidr_block    = "${module.my_vpc.vpc_cidr_block}"
#   vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
# }