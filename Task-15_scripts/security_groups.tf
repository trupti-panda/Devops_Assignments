# Create a Security Group for the Application
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.vpc_13.id
  name = "${var.vpc_name}_APP_SG"
  ingress {
		description = "SSH access from Jumphost"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
		security_groups = [aws_security_group.jump_host_sg.id]
        
  }

  ingress {
		description = "Access to Load Balancer"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
		description = "Access to Load Balancer"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
        Name = "${var.vpc_name}_APP_SG"
  }
}

# Create a Security Group for the Database
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc_13.id
  name = "${var.vpc_name}_DB_SG"
  ingress {
        description     = "MySQL access from Jump host"
    from_port   = 3306  # MySQL default port
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.jump_host_sg.id]  # Allow only jumphost  subnet communication
  }
  
  
  ingress {
	description = "MySQL access from App servers"
	from_port   = 3306  # MySQL default port
	to_port     = 3306
	protocol    = "tcp"
	security_groups = [aws_security_group.app_sg.id]  # Allow only application  subnet communication
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_DB_SG"
  }
}

# Create a Security Group for the JumpHOST
resource "aws_security_group" "jump_host_sg" {
  vpc_id = aws_vpc.vpc_13.id
  name = "${var.vpc_name}_JUMP_HOST_SG"
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH access from jump subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_JUMP_HOST_SG"
  }
}

# Create a Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc_13.id
  name = "${var.vpc_name}_LB_SG"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
  }
   ingress {
    description = "Allow SSH access from jump subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_LB_SG"
  }
}

