terraform {
  backend "s3" {
    bucket  = "dpf-terraform-state"
    region  = "eu-west-2"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
provider "aws" {
  region = "eu-west-2"
}
resource "aws_instance" "my-instance" {
  ami                    = "ami-dff017b8"
  instance_type          = "t2.micro"
  key_name               = "LondonKeyPair"
  vpc_security_group_ids = ["${aws_security_group.my-sg.id}"]
  user_data = "${file("userdata.sh")}"

  tags {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "my-sg" {
  name = "terraform-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Web Access"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Web Access"
  } 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Access"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  value = "${aws_instance.my-instance.public_ip}"
}
          
