# Associate jump Subnet with jump public  Route Table
resource "aws_route_table_association" "jump_route_subnet_association" {

  subnet_id      = aws_subnet.jump_subnet.id
  route_table_id = aws_route_table.jump_route.id
}
