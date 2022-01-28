resource "aws_autoscaling_group" "asg_ec2" {
  name                      = "asg-ec2"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.ec2_config.name
  vpc_zone_identifier       = concat(data.aws_subnet.all.*.id)
  target_group_arns         = [aws_lb_target_group.lb_group.arn]


tag {
    key                 = "Name"
    value               = "backend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = local.env
    propagate_at_launch = true
  }
  
  timeouts {
    delete = "15m"
  }
}

#Define uma política de autoscaling
resource "aws_autoscaling_policy" "load" {
  name                      = "lab-load-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg_ec2.name
  estimated_instance_warmup = 90

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

data "aws_ami" "ubuntu_asg" {
  owners      = ["099720109477"] #Owner ID da Canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

#Carrega um template e popula variáveis para gerar o script de inicialização das instâncias
data "template_file" "asg_userdata" {
  template = file("templates/userdata.tmpl")
  vars = {
    ENV     = local.env
    FS_NAME = "asg-${local.env}"
    REGION  = var.region
  }
}

#Define uma configuração de máquina para o autoscaling
resource "aws_launch_configuration" "ec2_config" {
  name          = "ec2-${local.env}"
  image_id      = data.aws_ami.ubuntu_asg.id
  instance_type = "t2.micro"
  key_name             = "ksilva"

  user_data       = data.template_file.asg_userdata.rendered #carrega o template com as configurações de inicialização da máquina
  security_groups = [aws_security_group.sgec2.id]

}
