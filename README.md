## Sample install scripts for different services

Status: experimental, use at your own risk.


### Missing parts:
* no error checking is done
* templating is very basic: no diffs displayed

### Nginx
(Loosely based on https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7)
* no parametrization or other configuration is done: always a proxy to port 8080 on localhost is configured

### PostgreSQL
* proof-of-concept: special care needs to be taken here not to trash existing PG installation

## License and authors
* Author: Timur Batyrshin <erthad@gmail.com>
* License: MIT
