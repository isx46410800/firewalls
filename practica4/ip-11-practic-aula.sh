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
iptables -A INPUT -s 192.168.2.56 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.56 -j ACCEPT

# (1) Fer NAT per les xarxes internes:
iptables -t nat -A POSTROUTING -s 172.200.0.0/24 -o enp5s0 -j MASQUERADE

# (2) Obrir el port 3001/3002 per accedir servei daytime-hostA i echo-hostB
iptables -t nat -A PREROUTING -p tcp --dport 3001 -i enp5s0 -j DNAT --to 172.200.0.2:13
iptables -t nat -A PREROUTING -p tcp --dport 3002 -i enp5s0 -j DNAT --to 172.200.0.3:7

# (3) Obrir els ports 4001/4002 per accedir als ssh
iptables -t nat -A PREROUTING -p tcp --dport 4001 -i enp5s0 -j DNAT --to 172.200.0.2:22
iptables -t nat -A PREROUTING -p tcp --dport 4002 -i enp5s0 -j DNAT --to 172.200.0.3:22

# (4) Als hosts de la xarxa privada interna se'ls permet navegar per internet,
#     però no cap altre accés a internet.
iptables -A FORWARD -s 172.200.0.0/16 -p tcp --dport 80 -o enp5s0 -j ACCEPT
iptables -A FORWARD -d 172.200.0.0/16 -p tcp --sport 80 -i enp5s0 -j ACCEPT
#iptables -A FORWARD -s 172.200.0.0/16 -o enp5s0 -j DROP  # talla tot el tràfic: tcp, udp icmp!!
#iptables -A FORWARD -d 172.200.0.0/16 -i enp5s0 -j DROP  # <idem>
iptables -A FORWARD -s 172.200.0.0/16 -p tcp -o enp5s0 -j DROP 
iptables -A FORWARD -s 172.200.0.0/16 -p udp -o enp5s0 -j DROP
iptables -A FORWARD -d 172.200.0.0/16 -p tcp -i enp5s0 -j DROP  
iptables -A FORWARD -d 172.200.0.0/16 -p udp -i enp5s0 -j DROP  

# (5) No es permet que els hosts de la xarxa interna facin ping a l'exterior.
iptables -A FORWARD -s 172.200.0.0/16 -p icmp --icmp-type=8 -o enp5s0 -j DROP

# (6) El router no contesta als pings que rep, però si que pot fer ping.
iptables -A INPUT  -p icmp --icmp-type=8 -j DROP
iptables -A OUTPUT -p icmp --icmp-type=0 -j DROP





