data "aws_ami" "ubuntu_mv" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_mv.id
  instance_type = "t2.micro"
  key_name      = "ksilva"
  tags = {
    Name = "maquina-teste-ec2"
  }
  security_groups = [aws_security_group.sgteste.name]
  user_data       = data.template_file.userdata.rendered
}

data "template_file" "userdata" {
  template = file("templates/userdata.tmpl")
  vars = {
    ENV     = local.env
    FS_NAME = "maquina-virtual-${local.env}"
    REGION  = var.region
  }
}
