provider "aws" {
  region = "eu-west-2"
}
resource "aws_instance" "my-instance" {
  ami           = "ami-403e2524"
  instance_type = "t2.micro"
  key_name = "LondonKeyPair"
  vpc_security_group_ids = ["${aws_security_group.mysg.id}"]
  user_data = <<-EOF
 #!/bin/bash
 sudo yum install httpd -y
 sudo yum update -y
 sudo service httpd start
 sudo chkconfig httpd on
 cd /var/www/html
 echo "<h1>Hello World</h1>" > index.html
 EOF
  tags {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "mysg" {
  name = "terraform-example-sg"
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

