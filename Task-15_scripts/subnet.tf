# Create Subnets
resource "aws_subnet" "subnet" {
  count                  = length(var.subnet_cidr_blocks)
  vpc_id                 = aws_vpc.vpc_13.id
  cidr_block             = var.subnet_cidr_blocks[count.index]
  availability_zone      = var.availability_zones[count.index % 3]  # Distribute across AZs
  map_public_ip_on_launch = false  # Do not associate public IPs

  tags = {
    Name = "Subnet-${count.index + 1}"
    Role = (
      count.index < 3 ? "Load Balancer" :
      (count.index >= 3 && count.index < 6 ? "Application" :
      "Database")
    )
  }
}

# Create jump Subnet
resource "aws_subnet" "jump_subnet" {
 
  vpc_id                 = aws_vpc.vpc_13.id
  cidr_block             = var.jump_subnet_cidr
  availability_zone      = var.jump_subnet_az
  map_public_ip_on_launch = true  #  associate public IPs

  tags = {
    Name = var.jump_subnet_name
  }
}

