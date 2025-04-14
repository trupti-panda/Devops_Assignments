
# Create a MySQL RDS instance in Private Subnets
resource "aws_db_instance" "My_rds_mysql" {
  identifier        = var.db_identifier
  engine            = "mysql"
  instance_class    = "db.${var.instance_class}"
  allocated_storage = var.db_storage
  storage_type      = var.db_storage_type
  username          = var.db_user_name
  password          = var.db_password
  db_name           = var.db_name
  multi_az          = true
  skip_final_snapshot = true
  publicly_accessible = false  # Ensure it's only accessible within the VPC
  db_subnet_group_name  = aws_db_subnet_group.db_sub_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  tags = {
    Name = "WordPress-DB"
  }
}
resource "aws_db_subnet_group" "db_sub_group" {
  name       = "db_subnet_group"
  subnet_ids =  [aws_subnet.subnet[6].id, aws_subnet.subnet[7].id, aws_subnet.subnet[8].id]

  tags = {
    Name = var.db_subnet_group_name
  }
}

