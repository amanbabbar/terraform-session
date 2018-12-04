
resource "aws_security_group" "aurora-sg" {
  name   = "aurora-security-group"
  vpc_id = "${var.vpc_id}"
  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = "${var.cluster_name}"
  engine                  = "aurora-mysql"
  database_name          = "sample_rds"
  master_username        = "${var.username}"
  master_password        = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.aurora-sg.id}"]
  #vpc_security_group_ids = ["${var.security_group_ids}"]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "${var.cluster_name}-instance"
  cluster_identifier = "${aws_rds_cluster.cluster.id}"
  instance_class     = "${var.instance_class}"
  publicly_accessible = "${var.publicly_accessible}"
  db_subnet_group_name    = "${aws_db_subnet_group.aurora_subnet_group.id}"
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "tf-rds-${var.cluster_name}"
  subnet_ids = ["${var.subnets}"]

  tags {
    Name = "tf-rds-${var.cluster_name}"
  }
}