# Create a Route Table for the Public Subnets (Load Balancer)
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_13.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.vpc_name}_ROUTE"
  }
}

# Create a Route Table for the Private Subnets 
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc_13.id



  tags = {
    Name = "${var.vpc_name}_PRIVATE_ROUTE"
  }
}


# Create a Route Table for the Public jump Subnet 
resource "aws_route_table" "jump_route" {
  vpc_id = aws_vpc.vpc_13.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.vpc_name}_JUMP_ROUTE"
  }
}
