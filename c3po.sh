#!/bin/bash
#echo "BORA BILL"

echo "Iniciando configuração dos arquivos DNS"
sleep 1
echo "# run resolvconf?
RESOLVCONF=yes

# startup options for the server
OPTIONS=\"-u bind -4\"" > /etc/default/named

echo "Criando zona DNS com domínio genérico superif.com.br"
sleep 1

echo "zone \"superif.com.br\" {
                type primary;
                file \"/etc/bind/zones/db/superif.com.br\";
};" > /etc/bind/named.conf.local

mkdir /etc/bind/zones
echo "criando arquivo de zona superif, lembre de alterar em /etc/bind/zones"
sleep 3
cp /etc/bind/db.local /etc/bind/zones/db.superif.com.br

echo "ns1.superif.com.br    IN    A    192.168.1.69
www    IN    A    200.100.50.80
ftp    IN    A    100.50.25.40
mail    IN    A    50.25.18.20
smtp    IN    A    25.10.10.5" >> /etc/bind/zones/db.superif.com.br

echo "Domínios genéricos para superif criados, altere em /etc/bind/zones/db.superif.com.br"
sleep 3

echo "Alterando arquivo resolv.conf"
echo "nameserver 192.168.1.69
search ." > /etc/resolv.conf
echo "Altere para seu IP em /etc/resolv.conf"
sleep 2
echo "Reinicie e verifique o status com systemctl restart bind9 e systemctl status bind9"
