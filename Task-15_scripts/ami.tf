resource "aws_ami_from_instance" "base_ami" {
  name               = "${var.vpc_name}_BASE_AMI"
  source_instance_id = aws_instance.jump_host.id
}
