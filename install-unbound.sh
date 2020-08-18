#!/bin/bash
echo "====================="
echo " Menginstall unbound"
echo "====================="
echo ""
apt-get install -y unbound dnsutils
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "apt-get install -y unbound dnsutils: ${myip}": ${myip}"

anu="s/@ipredirect/$myip/g"

wget ftp://ftp.internic.net/domain/named.cache -O /etc/unbound/
cp ./unbound.conf /etc/unbound/
sed -i -e $anu /etc/unbound/unbound.conf
unbound-control-setup
chown unbound:root /etc/unbound/unbound_*
chmod 440 /etc/unbound/unbound_*
unbound-checkconf /etc/unbound/unbound.conf
touch /var/log/unbound.log
chown unbound:unbound /var/log/unbound.log
echo "/var/log/unbound.log rw," > /etc/apparmor.d/local/usr.sbin.unbound
apparmor_parser -r /etc/apparmor.d/usr.sbin.unbound

service unbound restart
nslookup -port=5533 multipro.us 127.0.0.1
