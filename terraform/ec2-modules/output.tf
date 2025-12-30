output "instance_ip" {
  value = aws_instance.my_server.public_ip

}

output "ubuntu_ami_id" {
  value = data.aws_ami.my_ami.id
  
}

