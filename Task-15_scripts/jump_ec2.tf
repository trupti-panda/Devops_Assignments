resource "aws_instance" "jump_host" {
  ami             = var.jump_ami_id 
  instance_type   = var.jump_instance_type
  subnet_id       = aws_subnet.jump_subnet.id  # public jump  subnet 
  #security_groups = [aws_security_group.lb_sg.id]
  vpc_security_group_ids = [aws_security_group.jump_host_sg.id]
  associate_public_ip_address = true  # assign a public IP
  key_name = var.key_name
  user_data = data.template_file.wordpress_user_data.rendered

  tags = {
    Name = var.jump_host_name
  }
  depends_on = [aws_security_group.jump_host_sg]
}

