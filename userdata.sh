#!/bin/bash
sudo su
sudo update -y
sudo install -y httpd.x86_64

sudo systemctl start httpd.service
sudo systemctl enable httpd.service
cp /tmp/index.html /var/www/html/index.html 