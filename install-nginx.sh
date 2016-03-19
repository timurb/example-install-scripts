#!/bin/sh -e

PWD="$(dirname $0)"

sudo yum install -y epel-release
sudo yum install -y nginx

sudo systemctl enable nginx

if which firewall-cmd 2> /dev/null; then
  sudo firewall-cmd --permanent --zone=public --add-service=http 
  sudo firewall-cmd --permanent --zone=public --add-service=https
  sudo firewall-cmd --reload
fi

sudo "${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/nginx.conf.tpl" --json tomcat-proxy.json --out /etc/nginx/nginx.conf
sudo "${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/nginx-site.conf.tpl" --json tomcat-proxy.json --out /etc/nginx/conf.d/web-server.conf

sudo systemctl start nginx
