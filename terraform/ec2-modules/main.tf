locals {
  # normalized workspace name
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace
 
  # base app/project name
  project     = "app"
 
  # standard prefix pattern for all resources
  prefix      = "${local.project}-${local.environment}"
}

resource "aws_instance" "my_server" {
    associate_public_ip_address = true
    key_name = aws_key_pair.my_key.key_name
    instance_type = var.instance_type
    ami = data.aws_ami.my_ami.id
    subnet_id = var.subnet_id
    region = var.region
    availability_zone = var.az
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    # user_data =  file("ec2-modules/script.sh")

    tags ={
          Name= "${local.prefix}-server"
    }

}

resource "aws_key_pair" "my_key" {
  key_name   = "${local.prefix}-key"
  public_key = file("ec2-modules/my_key.pub")
  # public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_security_group" "my_sg" {
  name =" ${local.prefix}-sg"
  description = "anything"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


