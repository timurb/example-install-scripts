#!/bin/sh

sudo yum install -y epel-release
sudo yum install -y nginx

sudo systemctl enable nginx

if which firewall-cmd > /dev/null; then
  sudo firewall-cmd --permanent --zone=public --add-service=http 
  sudo firewall-cmd --permanent --zone=public --add-service=https
  sudo firewall-cmd --reload
fi 
