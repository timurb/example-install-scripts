#!/bin/sh -e

fail() (
  echo "ERROR: $*" >&2
  exit 1
)

PWD="$(dirname $0)"

[ "$(whoami)" != 'root' ] && fail "Run as 'root' user"

yum install -y epel-release
yum install -y nginx

systemctl enable nginx

if which firewall-cmd 2> /dev/null; then
  firewall-cmd --permanent --zone=public --add-service=http 
  firewall-cmd --permanent --zone=public --add-service=https
  firewall-cmd --reload
fi

"${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/nginx.conf.tpl" --json tomcat-proxy.json --out /etc/nginx/nginx.conf
"${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/nginx-site.conf.tpl" --json tomcat-proxy.json --out /etc/nginx/conf.d/web-server.conf

systemctl start nginx
