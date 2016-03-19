server {
    listen       80 default_server;
    server_name  _;

    location / {
      proxy_pass $proxy_address;
      proxy_set_header X-Real-IP $$remote_addr;
      proxy_set_header X-Scheme $$scheme;
      proxy_set_header Host $$host;
      proxy_http_version 1.1;      
    }
}
