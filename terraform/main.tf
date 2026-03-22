resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = "project"

  vpc_security_group_ids = [aws_security_group.react_app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "React-Ecommerce-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
