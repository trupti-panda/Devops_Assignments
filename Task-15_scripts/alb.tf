# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.vpc_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id, aws_subnet.subnet[2].id]
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "${var.vpc_name}_ALB"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.vpc_name}-APP-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_13.id
  health_check {
    protocol           = "HTTP"
    port               = "80"
    path               = "/"
    interval           = 30
    timeout            = 5
    healthy_threshold  = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}
