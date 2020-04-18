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


# Exemples port forwarding
#iptables -A FORWARD -p tcp --dport 13 -j REJECT
#iptables -A INPUT -p tcp --dport 13 -j REJECT
#iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT \
#	  --to 172.19.0.2:13
#iptables -t nat -A PREROUTING -p tcp --dport 5002 -j DNAT \
#          --to 172.19.0.3:13
#iptables -t nat -A PREROUTING -p tcp --dport 5003 -j DNAT \
#          --to :13
#iptables -t nat -A PREROUTING -p tcp --dport 6001 -j DNAT \
#	   --to 172.19.0.2:80
#iptables -t nat -A PREROUTING -p tcp --dport 6002 -j DNAT \
#           --to 10.1.1.0:80
#iptables -t nat -A PREROUTING -s 192.168.2.56 -p tcp \
#	   --dport 6000 -j DNAT --to :22
#iptables -t nat -A PREROUTING -s 172.19.0.0/24 -p tcp \
#          --dport 25 -j DNAT --to 192.168.2.56:25
#iptables -t nat -A PREROUTING -s 172.20.0.0/24 -p tcp \
#          --dport 25 -j DNAT --to 192.168.2.56:25
iptables -t nat -A PREROUTING -s 172.19.0.0/24 -p tcp \
          --dport 80 -j DNAT --to 192.168.2.56:80
iptables -t nat -A PREROUTING -s 172.20.0.0/24 -p tcp \
          --dport 80 -j DNAT --to 10.1.1.8:80






