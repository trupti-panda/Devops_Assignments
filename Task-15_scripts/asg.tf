
# Launch Configuration for Auto Scaling Group

resource "aws_launch_template" "app_launch_template" {
  name = "${var.vpc_name}_LAUNCH_TEMPLATE"

  # Define the launch template configuration
  image_id      = aws_ami_from_instance.base_ami.id # Replace with your AMI ID
  instance_type = var.instance_type  # Replace with your desired instance type

  key_name = var.key_name # Optional: Replace with your key pair name

  #security_group_names = [aws_security_group.app_sg.id]  # Optional: Replace with your security group name(s)
  vpc_security_group_ids  = ["${aws_security_group.app_sg.id}"] 
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MyInstance"
    }
  }

  # Other optional configurations like EBS, IAM roles, etc.
}

# Auto Scaling Group


resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.subnet[3].id, aws_subnet.subnet[4].id, aws_subnet.subnet[5].id]

  # Correct way to reference Launch Template
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    #name    = aws_launch_template.app_launch_template.name
    version = "$Latest"  # Use the latest version, or specify a version number
  }
  #security_groups = [aws_security_group.app_sg.id]
  target_group_arns    = [aws_lb_target_group.app_target_group.arn]
  health_check_type    = "EC2"  # Keep only this; 

  health_check_grace_period = 300  # Optional: time for instance to warm up before it's considered unhealthy
  force_delete             = true
   tag {
      key                 = "Name"
      value               = "${var.vpc_name}_EC2"
      propagate_at_launch = true
    }
}


resource "aws_autoscaling_policy" "app_scale_policy" {
  name                   = "${var.vpc_name}_SCALE_POLICY"
  policy_type             = "TargetTrackingScaling"  # Use a single TargetTrackingScaling policy
  autoscaling_group_name   = aws_autoscaling_group.app_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0  # This will automatically scale up or down based on the target CPU utilization
  }
}

