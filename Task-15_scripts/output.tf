
# Output the VPC ID and Subnet IDs
output "vpc_id" {
  value = aws_vpc.vpc_13.id
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}

output "subnet_roles" {
  value = aws_subnet.subnet[*].tags["Role"]
}
output "jump_sg" {
	value = aws_security_group.jump_host_sg.name
}
#output "asg"{
#	value = aws_autoscaling_group.app_asg.name
#}
#
#
#output "launce_template" {
#
#	value = aws_launch_template.app_launch_template.name
#}
