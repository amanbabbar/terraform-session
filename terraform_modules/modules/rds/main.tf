

data "aws_subnet" "selected" {
  id = "${var.ec2_subnet_id}"
}


resource "aws_db_instance" "default" {
  #depends_on             = ["aws_security_group.sg-rds"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.allocated_storage}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.instance_class}"
  #name                   = "${var.name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.aurora-sg.id}"]
  db_subnet_group_name   = "${var.db_subnet_group_name}"
  multi_az               = "${var.multi_az}"
  publicly_accessible = "${var.publicly_accessible}"
  skip_final_snapshot = "${var.skip_final_snapshot}"
}

resource "aws_security_group" "aurora-sg" {
  name   = "aurora-security-group"
  vpc_id = "${var.vpc_id}"
  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["${data.aws_subnet.selected.cidr_block}"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}