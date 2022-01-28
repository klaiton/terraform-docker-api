resource "aws_lb" "lb_ec2" {
  name               = "lb-ec2-${local.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sglb.id]
  subnets            = concat(data.aws_subnet.all.*.id)

  access_logs {
    bucket  = aws_s3_bucket.lb_access_logs.id
    prefix  = var.access_log_prefix
    enabled = true
  }

  tags = {
    Environment = local.env
    Name        = "desafio"
    Project     = var.project
  }
}

resource "aws_lb_target_group" "lb_group" {
  name     = "lb-target-group-${local.env}"
  port     = 8848
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
  
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path    = "/"
    matcher = "200,302"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb_ec2.arn
  port              = "8848"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_group.arn
  }
}


