#!/bin/bash
yum install httpd -y
yum update -y
chkconfig httpd on
service httpd start
cd /var/www/html
echo "<h1>This site is now available!</h1>" > index.html
