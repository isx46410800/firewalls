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


# Exemples de regles output
################################################
# accedir a qualsevol port/destí
  #iptables -A OUTPUT -j ACCEPT
# accedir a port 13 de qualsevol destí
  #iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT
  #iptables -A OUTPUT -p tcp --dport 13 -d 0.0.0.0/0  -j ACCEPT
# accedir a qualsevol port 2013 excepte el del host2
  #iptables -A OUTPUT -p tcp --dport 2013 -d 192.168.1.44 -j REJECT
  #iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT
# denegat accedir a qualsevol port 3013, però si al del host2
  #iptables -A OUTPUT -p tcp --dport 3013 -d 192.168.1.44 -j ACCEPT
  #iptables -A OUTPUT -p tcp --dport 3013 -j REJECT
# obert acces 4013 a tothom, tancar a casa i obert a host 2
  #iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.1.44 -j ACCEPT
  #iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.1.0/24 -j REJECT
  #iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT
# xapar accés a qualsevol dels ports 80, 13 i 7
  #iptables -A OUTPUT -p tcp --dport 80 -j REJECT
  #iptables -A OUTPUT -p tcp --dport 13 -j REJECT
  #iptables -A OUTPUT -p tcp --dport 7  -j REJECT
# no permetre accedir al host 2 ni al docker net1
  #iptables -A OUTPUT -d 192.168.1.44 -j REJECT
  #iptables -A OUTPUT -d 172.19.0.2 -j REJECT
# no permetre accedir a les xarxes casa i mynet
  #iptables -A OUTPUT -d 192.168.1.0/24 -j REJECT
  #iptables -A OUTPUT -d 172.19.0.0/16 -j REJECT
# a la xarxa mynet no s'hi pot accedir excepte per ssh
  iptables -A OUTPUT -p tcp --dport 22 -d 172.19.0.0/16 -j ACCEPT
  iptables -A OUTPUT -d 172.19.0.0/16 -j REJECT

# Mostrar les regles generades
iptables -L -t nat




