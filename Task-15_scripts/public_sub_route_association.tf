# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_association" {
  count          = 3  # Public subnets (first 3)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

