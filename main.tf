provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "my-instance" {
  ami                    = "ami-403e2524"
  instance_type          = "t2.micro"
  key_name               = "LondonKeyPair"
  vpc_security_group_ids = ["${aws_security_group.my-sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "my-sg" {
  name = "terraform-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = "${aws_instance.my-instance.public_ip}"
}
          
