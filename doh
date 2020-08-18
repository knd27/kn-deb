upstream dns-backend {
    server 127.0.0.1:8053;
}
server {
        listen 80;
        server_name @servername;
        root /var/www/html;
        #access_log /var/log/nginx/dns.access.log;
        location /dns-query {
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_set_header X-NginX-Proxy true;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_redirect off;
                proxy_set_header        X-Forwarded-Proto $scheme;
                proxy_read_timeout 86400;
                proxy_pass http://dns-backend/dns-query ;
        }

	# Add index.php to the list if you are using PHP
        index  index.php index.html index.htm index.nginx-debian.html;


        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

#        location ~ \.php$ {
#                include fastcgi_params;
#                fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
#                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
#                fastcgi_param FQDN true;
#                auth_basic "Restricted"; # For Basic Auth
#                auth_basic_user_file /etc/nginx/.htpasswd; # For Basic Auth
#        }


    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/@servername/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/@servername/privkey.pem;

	ssl_session_cache shared:le_nginx_SSL:10m;
        ssl_session_timeout 1440m;
        ssl_session_tickets off;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers off;

	ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA";

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    ssl_stapling on;
    ssl_stapling_verify on;
}
