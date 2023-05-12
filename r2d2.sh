#!/bin/bash
#echo "BORA BILL"
echo "Iniciando configuração dos arquivos de DHCP com valores padrão"
sleep 2

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old

echo "# dhcpd.conf
#
# Configuration file for ISC dhcpd (see 'man dhcpd.conf')
#
authoritative;
#Domínio configurado no BIND
#option domain-name seudominio.com.br;
default-lease-time 600; #controla o tempo de renovação do IP
max-lease-time 7200; #determina o tempo que cada máquina pode usar um determinado IP. 

subnet 192.168.1.0 netmask 255.255.255.0 { #Define sua sub-rede 192.168.1.0 com a máscara 255.255.255.0 
     range 192.168.1.101 192.168.1.200;  #faixa de IPs que o cliente pode usar.
     option routers 192.168.1.100; #Este é o gateway padrão (neste caso).
     option broadcast-address 192.168.1.255; #Essa linha é o endereço de broadcast (neste caso).

#Aqui você coloca os servidores DNS de terceiros ou seu DNS próprio configurado no BIND. Nesse caso coloquei o DNS do Google.
     option domain-name-servers 8.8.8.8; 
     option domain-name-servers  8.8.4.4;
}" > /etc/dhcp/dhcpd.conf

sleep 1
echo "Configuração do DHCP realizada em /etc/dhcp/dhcpd.conf, altere os valores de IP"
sleep 5
clear

echo "Iniciando configuração do arquivo netplan"
sleep 2

cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.backup
mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.old

echo "# This is the network config writter by 'subiquity'
network:
  ethernets:
    enp0s3:
      addresses:
        - 192.168.1.69/24
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
        routers:
          - to: default
            via: 192.168.1.100
      dhcp4: false
  version: 2" > /etc/netplan/00-installer-config.yaml

echo "Arquivo netplan configurado em /etc/netplan/00-installer-config.yaml, altere os valores de IP e utilize o comando netplan apply"
sleep 3
echo "Verifique novamente os arquivos, reinicie o serviço e verifique o status"
echo "Comando para reiniciar o dhcp: systemctl restart isc-dhcp-server.service"
echo "Comando para verificar o dhcp: systemctl status isc-dhcp-server.service"
sleep 7
