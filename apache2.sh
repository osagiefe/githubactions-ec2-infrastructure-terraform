#!/bin/bash
# install the nginx web server
sudo apt-get update
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
##sudo apt-get install git -y
cp /tmp/index.html /var/www/html/index.html 