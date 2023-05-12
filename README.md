# Configurações de servidores para a aula de SESA

<h2>Procedimentos gerais</h2>
sudo su -
<br>#obter permissões
<br>apt-get update && apt install isc-dhcp-server apache2 bind9 bind9utils bind9-doc net-tools vsftpd -y
<br>#instalar servidores DHCP, HTTP, DNS e FTP
<h2>Transferindo os scripts DHCP e DNS com FTP</h2>
nano /etc/vsftpd.conf
<br>#remover a hashtag da linha #write_enable=YES
<br>systemctl restart vsftpd && systemctl status vsftpd
<br>#transferir r2d2.sh (DHCP) e c3po.sh (DNS) pelo Filezilla
<h3>DHCP</h3>

chmod +x r2d2.sh && ./r2d2.sh
<br>#permite e executa configurações padrões nos arquivos /etc/dhcp/dhcpd.conf e /etc/netplan/00-installer-config.yaml
<br>#altere os valores de IP, placa de rede, e outros valores pertinentes
<br>netplan apply && systemctl restart isc-dhcp-server.service && systemctl status isc-dhcp-server.service
<h4>Ações do script</h4>

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup && mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old

<br>#cria um backup do arquivo original e este é renomeado como backup adicional

<br>echo "# dhcpd.conf
<br>#
<br># Configuration file for ISC dhcpd (see 'man dhcpd.conf')
<br>#
<br>authoritative;
<br>#Domínio configurado no BIND
<br>#option domain-name seudominio.com.br;
<br>default-lease-time 600; #controla o tempo de renovação do IP
<br>max-lease-time 7200; #determina o tempo que cada máquina pode usar um determinado IP.
<br>
<br>subnet 192.168.1.0 netmask 255.255.255.0 { #Define sua sub-rede 192.168.1.0 com a máscara 255.255.255.0
<br>range 192.168.1.101 192.168.1.200; #faixa de IPs que o cliente pode usar.
<br>option routers 192.168.1.100; #Este é o gateway padrão (neste caso).
<br>option broadcast-address 192.168.1.255; #Essa linha é o endereço de broadcast (neste caso).
<br>
<br>#Aqui você coloca os servidores DNS de terceiros ou seu DNS próprio configurado no BIND. Nesse caso coloquei o DNS do Google.
<br>option domain-name-servers 8.8.8.8;
<br>option domain-name-servers 8.8.4.4;
<br>}" > /etc/dhcp/dhcpd.conf
<br>
<br>#modifica o arquivo de configurações com valores genéricos para um endereço IP 192.168.1.69
<br>
<br>cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.backup && mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.old
<br><br>
#cria um backup do arquivo original e este é renomeado como backup adicional
<br>
<br>echo "# This is the network config writter by 'subiquity'
<br>network:
<br>ethernets:
<br>enp0s3:
<br>addresses:
<br>- 192.168.1.69/24
<br>nameservers:
<br>addresses: [8.8.8.8, 8.8.4.4]
<br>routes:
<br>- to: default
<br>via: 192.168.1.100
<br>dhcp4: false
<br>version: 2" > /etc/netplan/00-installer-config.yaml
<br><br>
#modifica o arquivo de configurações com valores genéricos para um endereço IP 192.168.1.69
<h3>DNS</h3>

chmod +x c3po.sh && ./c3po.sh
<br>#permite e executa configurações padrões nos arquivos /etc/default/named, /etc/resolv.conf e /etc/bind/zones/db.superif.com.br
<br>#altere os valores de IP, placa de rede, domínio e outros valores pertinentes
<br>systemctl restart bind9 && systemctl status bind9 && nslookup
<h4>Ações do script</h4>

echo "# run resolvconf?
<br>RESOLVCONF=yes
<br>#startup options for the server
<br>OPTIONS=\"-u bind -4\"" > /etc/default/named
<br><br>
#modifica o arquivo de configuração do bind
<br><br>
echo "zone \"superif.com.br\" {
<br>type primary;
<br>file \"/etc/bind/zones/db/superif.com.br\";
<br>};" > /etc/bind/named.conf.local
<br><br>
#modifica o arquivo adicionando uma zona genérica
<br><br>
mkdir /etc/bind/zones
<br><br>
#cria um diretório para os arquivos de zona
<br><br>
cp /etc/bind/db.local /etc/bind/zones/db.superif.com.br
<br><br>
#copia um arquivo default para editá-lo
<br><br>
echo "ns1.superif.com.br IN A 192.168.1.69
<br>www IN A 200.100.50.80
<br>ftp IN A 100.50.25.40
<br>mail IN A 50.25.18.20
<br>smtp IN A 25.10.10.5" >> /etc/bind/zones/db.superif.com.br
<br><br>
#cria domínios genéricos no arquivo de zona
<br><br>
echo "nameserver 192.168.1.69
<br>search ." > /etc/resolv.conf
<br><br>
#altera o arquivo resolv.conf com o IP
<br><br>
<h2>HTTP</h2>
systemctl restart apache2 && systemctl status apache2
<br>Altere o arquivo html em /var/www/html/index.html
