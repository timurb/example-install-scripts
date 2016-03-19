#!/bin/sh -e

fail() (
  echo "ERROR: $*" >&2
  exit 1
)

PWD="$(dirname $0)"

[ "$(whoami)" != 'root' ] && fail "Run as 'root' user"
[ -d /var/lib/pgsql/9.4/data ] && fail "PostgreSQL 9.4 looks to be installed. Aborting installation"

yum install -y http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
yum install -y postgresql94-server postgresql94-contrib
chkconfig postgresql-9.4 on

/usr/pgsql-9.4/bin/postgresql94-setup init

"${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/postgresql.conf.tpl" --json postgresql.json --out /var/lib/pgsql/9.4/data/postgresql.conf
"${PWD}/gen-template/gen-template.py" --force --template "${PWD}/templates/pg_hba.conf.tpl" --json postgresql.json --out /var/lib/pgsql/9.4/data/pg_hba.conf

service postgresql-9.4 start
