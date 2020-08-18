#!/bin/bash
echo "========================"
echo " Menginstall DoH Server"
echo "========================"
echo ""
echo -e "Server Name: "
read servername
echo "DNS Upstream:  "
echo "setting sendiri file:"
echo -e "/etc/dns-over-https/doh-server.conf"
read dnsupstream

wget https://www.aaflalo.me/doh-server/doh-server_2.0.1_amd64.deb
dpkg -i doh-server_2.0.1_amd64.deb
apt install -y nginx-full certbot  python3-certbot-nginx

cp doh /etc/nginx/sites-available/
anu="s/@servername/$servername/g"
sed -i -e $anu  /etc/nginx/sites-available/doh
ln -s /etc/nginx/sites-available/doh /etc/nginx/sites-enabled/doh

echo "** Let's encrypt install.. "
echo ""
certbot  -d $servername --manual --preferred-challenges dns certonly
systemctl restart nginx

nano /etc/dns-over-https/doh-server.conf
