# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "subnet-private_association" {
  count          = 6  # Private subnets (remaining 6)
  subnet_id      = aws_subnet.subnet[count.index + 3].id
  route_table_id = aws_route_table.private_route.id
}
