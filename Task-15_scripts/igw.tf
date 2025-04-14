# Create an Internet Gateway for Public Subnets
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc_13.id

  tags = {
    Name = "${var.vpc_name}_IGW"
  }
}

