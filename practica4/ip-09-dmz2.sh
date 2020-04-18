#! /bin/bash
# @edt ASIX M11-SAD Curs 2018-2019
# iptables

#echo 1 > /proc/sys/ipv4/ip_forward

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
iptables -A INPUT -s 192.168.0.18 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.18 -j ACCEPT

# Fer NAT per les xarxes internes:
# - 172.19.0.0/24
# - 172.20.0.0/24
iptables -t nat -A POSTROUTING -s 172.19.0.0/24 -o enp6s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -o enp6s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.21.0.0/24 -o enp6s0 -j MASQUERADE

# Regles de DMZ
# ###########################################################

# (1) des d'un host exterior accedir al servei ldap de la DMZ.
iptables -t nat -A PREROUTING -p tcp --dport 389 -i enp6s0 -j DNAT \
         	--to 172.21.0.6:389
iptables -t nat -A PREROUTING -p tcp --dport 636 -i enp6s0 -j DNAT \
                --to 172.21.0.6:636

# (2) des d'un host exterior, engegar un container kclient i 
# obtenir un tiket kerberos del servidor de la DMZ.
iptables -t nat -A PREROUTING -p tcp --dport 88 -i enp6s0 -j DNAT \
                --to 172.21.0.4:88
iptables -t nat -A PREROUTING -p tcp --dport 543 -i enp6s0 -j DNAT \
                --to 172.21.0.4:543
iptables -t nat -A PREROUTING -p tcp --dport 749 -i enp6s0 -j DNAT \
                --to 172.21.0.4:749
iptables -t nat -A PREROUTING -p tcp --dport 544 -i enp6s0 -j DNAT \
                --to 172.21.0.4:544

# (3) des d'un host exterior emuntar un recurs samba del servidor 
# de la DMZ. Ports: 
iptables -t nat -A PREROUTING -p tcp --dport 139 -i enp6s0 -j DNAT \
                --to 172.21.0.5:139
iptables -t nat -A PREROUTING -p tcp --dport 445 -i enp6s0 -j DNAT \
                --to 172.21.0.5:445







