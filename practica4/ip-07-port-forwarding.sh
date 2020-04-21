#! /bin/bash
# @edt ASIX M11-SAD Curs 2018-2019
# iptables Miguel Amorós

echo 1 > /proc/sys/net/ipv4/ip_forward

# Regles flush
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Polítiques per defecte: 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# obrir la nostra ip
iptables -A INPUT -s 192.168.1.104 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.104 -j ACCEPT

# Fer NAT per les xarxes internes:
# - 172.18.0.0/16
# - 172.19.0.0/16
iptables -t nat -A POSTROUTING -s 172.18.0.0/16 -o enp4s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.19.0.0/16 -o enp4s0 -j MASQUERADE


# Exemples port forwarding
#Rechazamos la conexión por el puerto13
#iptables -A FORWARD -p tcp --dport 13 -j REJECT
#iptables -A INPUT -p tcp --dport 13 -j REJECT

#Redirigimos conexiones externas abriendo un nuevo puerto y conectarlo a un servicio de otro host
#iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT --to 172.18.0.2:13
#iptables -t nat -A PREROUTING -p tcp --dport 5002 -j DNAT --to 172.18.0.3:13
#iptables -t nat -A PREROUTING -p tcp --dport 5003 -j DNAT --to :13

#Idem de lo anterior pero con el servicio del puerto 80 a dos redes distintas
#iptables -t nat -A PREROUTING -p tcp --dport 6001 -j DNAT --to 192.168.1.104:80
#iptables -t nat -A PREROUTING -p tcp --dport 6002 -j DNAT --to 172.18.0.2:7

# si viene del host2 abrimos puerto 6000 y lo redirigimos al ssh
#iptables -t nat -A PREROUTING -s 192.168.1.44 -p tcp --dport 6000 -j DNAT --to :22

#iptables -t nat -A PREROUTING -s 172.18.0.2 -p tcp --dport 25 -j DNAT --to 192.168.1.104:25
#iptables -t nat -A PREROUTING -s 172.19.0.2/16 -p tcp --dport 25 -j DNAT --to 192.168.1.104:25

# si viene del host 2 accede al puerto 7080 del host principal
iptables -t nat -A PREROUTING -s 192.168.1.44 -p tcp --dport 7080 -j DNAT --to 192.168.1.104:80
#iptables -t nat -A PREROUTING -s 172.19.0.0/16 -p tcp --dport 80 -j DNAT --to 192.168.1.104:80


# Mostrar les regles generades
iptables -L -t nat

