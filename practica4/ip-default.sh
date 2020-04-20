#! /bin/bash
# @edt ASIX M11-SAD Curs 2018-2019
# iptables Miguel Amorós


#echo 1 > /proc/sys/net/ipv4/ip_forward

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

# Mostrar les regles generades
iptables -L -t nat





