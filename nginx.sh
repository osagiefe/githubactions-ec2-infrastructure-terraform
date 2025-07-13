#!/bin/bash
sudo su
sudo apt update -y
sudo install -y nginx

sudo systemctl start nginx.service
sudo systemctl enable nginx
sudo systemctl status nginx