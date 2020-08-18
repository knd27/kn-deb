#!/bin/bash
echo "============================="
echo " Menginstall DoH Cloudflare"
echo ""
echo "============================="
echo ""
echo "Pilih Jenis DNS Cloudflare:"
echo " 1. Umum (loss dool)"
echo " 2. Anti Malware"
echo " 3. Anti Malware & Adult"
echo -n "Pilihan (1) : "
read n12
case $n12 in
  "1" ) ndom="CLOUDFLARED_OPTS=--port 5353 --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query"
;;
"2" ) ndom="CLOUDFLARED_OPTS=--port 5353 --upstream https://security.cloudflare-dns.com/dns-query"
;;
"3" ) ndom="CLOUDFLARED_OPTS=--port 5353 --upstream https://family.cloudflare-dns.com/dns-query"
;;
*)  ndom="CLOUDFLARED_OPTS=--port 5353 --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query"
;;
esac

apt-get install -y curl
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
dpkg -i cloudflared-stable-linux-amd64.deb 
cloudflared --version
useradd -r -M -s /usr/sbin/nologin -c "Cloudflared user" cloudflared
grep '^cloudflared' /etc/passwd
id cloudflared
passwd -l cloudflared
chage -E 0 cloudflared
chage -l cloudflared
echo "$ndom" > /etc/default/cloudflared
chown -v cloudflared:cloudflared /usr/local/bin/cloudflared /etc/default/cloudflared
cp  cloudflared.service  /lib/systemd/system/
systemctl enable cloudflared
systemctl start cloudflared
systemctl status cloudflared

echo "** tes............."
dig -p 5353 www.nixcraft.com @127.0.0.1
dig -p 5353 www.multipro.us @127.0.0.1
curl https://cloudflare.com/cdn-cgi/trace
