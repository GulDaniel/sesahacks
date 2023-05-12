#Configurações de servidores para a aula de SESA

Procedimentos gerais
sudo su -
#obter permissões
apt-get update && apt install isc-dhcp-server, apache2, bind9, bind9utils, bind9-doc, net-tools, vsftpd
#instalar servidores DHCP, HTTP, DNS e FTP
Transferindo os scripts DHCP e DNS
nano /etc/vsftpd.conf
#remover a hashtag da linha #write_enable=YES
systemctl restart vsftpd && systemctl status vsftpd
#transferir r2d2.sh (DHCP) e c3po.sh (DNS) pelo Filezilla
DHCP

chmod +x r2d2.sh && ./r2d2.sh
#permite e executa configurações padrões nos arquivos /etc/dhcp/dhcpd.conf e /etc/netplan/00-installer-config.yaml
#altere os valores de IP, placa de rede, e outros valores pertinentes
netplan apply && systemctl restart isc-dhcp-server.service && systemctl status isc-dhcp-server.service
Ações do script

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup && mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old

#cria um backup do arquivo original e este é renomeado como backup adicional

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
range 192.168.1.101 192.168.1.200; #faixa de IPs que o cliente pode usar.
option routers 192.168.1.100; #Este é o gateway padrão (neste caso).
option broadcast-address 192.168.1.255; #Essa linha é o endereço de broadcast (neste caso).

#Aqui você coloca os servidores DNS de terceiros ou seu DNS próprio configurado no BIND. Nesse caso coloquei o DNS do Google.
option domain-name-servers 8.8.8.8;
option domain-name-servers 8.8.4.4;
}" > /etc/dhcp/dhcpd.conf

#modifica o arquivo de configurações com valores genéricos para um endereço IP 192.168.1.69

cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.backup && mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.old

#cria um backup do arquivo original e este é renomeado como backup adicional

echo "# This is the network config writter by 'subiquity'
network:
ethernets:
enp0s3:
addresses:
- 192.168.1.69/24
nameservers:
addresses: [8.8.8.8, 8.8.4.4]
routes:
- to: default
via: 192.168.1.100
dhcp4: false
version: 2" > /etc/netplan/00-installer-config.yaml

#modifica o arquivo de configurações com valores genéricos para um endereço IP 192.168.1.69
DNS

chmod +x c3po.sh && ./c3po.sh
#permite e executa configurações padrões nos arquivos /etc/default/named, /etc/resolv.conf e /etc/bind/zones/db.superif.com.br
#altere os valores de IP, placa de rede, domínio e outros valores pertinentes
systemctl restart bind9 && systemctl status bind9 && nslookup
Ações do script

echo "# run resolvconf?
RESOLVCONF=yes

# startup options for the server
OPTIONS=\"-u bind -4\"" > /etc/default/named

#modifica o arquivo de configuração do bind

echo "zone \"superif.com.br\" {
type primary;
file \"/etc/bind/zones/db/superif.com.br\";
};" > /etc/bind/named.conf.local

#modifica o arquivo adicionando uma zona genérica

mkdir /etc/bind/zones

#cria um diretório para os arquivos de zona

cp /etc/bind/db.local /etc/bind/zones/db.superif.com.br

#copia um arquivo default para editá-lo

echo "ns1.superif.com.br IN A 192.168.1.69
www IN A 200.100.50.80
ftp IN A 100.50.25.40
mail IN A 50.25.18.20
smtp IN A 25.10.10.5" >> /etc/bind/zones/db.superif.com.br

#cria domínios genéricos no arquivo de zona

echo "nameserver 192.168.1.69
search ." > /etc/resolv.conf

#altera o arquivo resolv.conf com o IP
