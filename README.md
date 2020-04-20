# <u>__PRÁCTICA 4 - FIREWALLS__</u>

## __IPs__
+ __IP host principal:__ 192.168.1.104  
+ __IP host 2:__ 192.168.1.44  
+ __IP dockers:__ 172.19.0.2  / 172.19.0.3 / 172.19.0.4  
`[isx46410800@miguel firewalls]$ docker run --rm --name net1 -h net1 --net mynet -d isx46410800/firewalls:net19`  
`[isx46410800@miguel firewalls]$ docker run --rm --name net2 -h net2 --net mynet -d isx46410800/firewalls:net19`  
`[isx46410800@miguel firewalls]$ docker run --rm --name net3 -h net3 --net mynet -d isx46410800/firewalls:net19`  

## __Conceptos previos__  
+ __drop y reject:__ reject te informa del error mientras que drop agota el tiempo de espera sin notificar al momento del error de conexión.  
+ __related y established:__ ESTABLISHED el paquete seleccionado se asocia con otros paquetes en una conexión establecida mientras que RELATED el paquete seleccionado está iniciando una nueva conexión en algún punto de la conexión existente.
+ __-j:__  tipo de salto/objetivo (accept, drop, reject...)
+ __-d:__ destino
+ __-s:__ origen
+ __-F:__ flush, vaciar    
+ __-A:__ append
+ __-P:__ política de accept o drop   
+ __-I:__ insertar  
+ __--dport:__ configura el puerto de destino para el paquete.
+ __--sport:__ configura el puerto de origen para el paquete.      
+ __-p:__ protocolo   
+ __--icmp-type 8:__ ICMP type 8, Echo request message.  
+ __--icmp-type 0:__ ICMP type 0, Echo reply message.  


## __Ejemplo Inicial: `ip-default.sh`__
En este ejemplo borramos todas las reglas actuales, establecemos una politica por defecto de todo abierto, permite todo el tráfico de entrada/salida en loopback y en nuestra IP host local. (Igualmente por defecto la politica por defecto ACCEPT ya lo hacía). También indicamos si el host hace de router, en este caso no.

[script ip-default.sh](practica4/ip-default.sh)  

+ En cada script ponemos la orden `iptables -L -t nat` para que al ejecutarlo, nos muestre las reglas generadas:  
```
[root@miguel firewalls]# ./ip-default.sh
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
Chain DOCKER (0 references)
target     prot opt source               destination   
```

#### __COMPROBACIONES__  
+ Entre un host principal y otro ordenador(host 2) hacemos intercambio de pings, ssh, telnet de servicios echo, daytime... para comprobar que en efecto, sí se acepta todo tipo de conexiones de entrada y salida propias de la interficie y del loopback.

![](capturas/fire1.png)

![](capturas/firewall1.png)

![](capturas/firewall2.png)

![](capturas/firewall3.png)


## __Ejemplo 01: `ip-01-input.sh`__  
En este ejemplo continuamos con la misma parte de por defecto pero ahora establecemos unas serie de reglas `INPUT` para el tráfico de entrada por nuestro puerto 80. Los diferentes puertos abiertos relacionados con el puerto 80 de httpd están configurados en `/etc/xinetd.d/`.  

En nuestro caso empleamos dos ordenadores, el principal y el host2. Hemos establecido reglas en que según que puerto indiquemos (2080,3080...) permitiremos que nuestro host2 pueda o no acceder o que otros hosts de la red puedan conectarnos por estos puertos. Las reglas iptables en este apartado están puestas en el host principal.  

[script ip-01-input.sh](practica4/ip-01-input.sh)  

#### __COMPROBACIONES__  
+ Seguimos viendo que para conectarnos al host2 no tenemos problemas ya que no hemos cambiado ninguna regla de `OUTPUT`  

![](capturas/fire2.png)

+ Aquí sí podemos ver que ahora al conectarnos según que puerto nos permite o no el acceso desde host2: por ejemplo, por el puerto 2080, 3080, 5080 y 6080 no podrá acceder pero sí por el puerto 4080 y 7080.  

![](capturas/firewall4.png)

![](capturas/firewall5.png)

## __Ejemplo 02: `ip-02-ouput.sh__
En este ejemplo continuamos con la misma parte de por defecto pero ahora establecemos unas serie de reglas `OUTPUT` para el tráfico de SALIDA por nuestro puerto 13. Los diferentes puertos abiertos relacionados con el puerto 13 del servicio daytime están configurados en `/etc/xinetd.d/`.  

En nuestro caso empleamos dos ordenadores, el principal (con 3 hosts de containers) y el host2. Hemos establecido reglas en que según que puerto indiquemos (2013,3013...) permitiremos que nuestro principal pueda o no acceder al host2 o a los host de los containers. Las reglas iptables en este apartado están puestas en el principal.  

[script ip-02-ouput.sh](practica4/ip-02-ouput.sh)  

#### __COMPROBACIONES__  
+ Acceder a port 13 de cualquier destino:  
  `iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT`  
  `iptables -A OUTPUT -p tcp --dport 13 -d 0.0.0.0/0  -j ACCEPT`  

![](capturas/fire6.png)

> Vemos que podemos acceder al puerto 13 de cualquier host

+ Acceder a cualquier puerto 2013 excepto el de host2:  
  `iptables -A OUTPUT -p tcp --dport 2013 -d 192.168.1.44 -j REJECT`  
  `iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT`  

![](capturas/fire7.png)

> Vemos que en este caso no podemos acceder al puerto 2013 del host2

+ Denegado acceder a cualquier puerto 3013 pero sí al del host2:  
  `iptables -A OUTPUT -p tcp --dport 3013 -d 192.168.1.44 -j ACCEPT`  
  `iptables -A OUTPUT -p tcp --dport 3013 -j REJECT`  

![](capturas/fire8.png)

> Vemos que podemos acceder al puerto 3013 del host2

+ Abierto a todos el puerto 4013, cerrado a casa y abierto a host2:  
  `iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.1.44 -j ACCEPT`  
  `iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.1.0/24 -j REJECT`  
  `iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT`  

![](capturas/fire9.png)

> Vemos que está abierto para acceder a host2 y para net1

+ Cerrado cualquier acceso a los puertos 80, 13 u 7:  
  `iptables -A OUTPUT -p tcp --dport 80 -j REJECT`  
  `iptables -A OUTPUT -p tcp --dport 13 -j REJECT`  
  `iptables -A OUTPUT -p tcp --dport 7  -j REJECT`  

![](capturas/fire10.png)

> Vemos que están cerrados todos los accesos a los puertos 80,13 y 7 tanto para conectar a host2 como net1.

+ No permitir acceder ni al host2 ni a net1:  
  `iptables -A OUTPUT -d 192.168.1.44 -j REJECT`  
  `iptables -A OUTPUT -d 172.19.0.2 -j REJECT`  

![](capturas/fire11.png)

> En este caso está cerrado tanto para host2 y net1 cualquier acceso a ellos.

+ No permitir acceder a las redes de casa y mynet:  
  `iptables -A OUTPUT -d 192.168.1.0/24 -j REJECT`
  `iptables -A OUTPUT -d 172.19.0.0/24 -j REJECT`  

![](capturas/fire12.png)

> No podemos acceder a las redes de casa ni de mynet por ninguno de sus puertos.

+ A la red mynet no se puede acceder, solo por ssh:  
  `iptables -A OUTPUT -p tcp --dport 22 -d 192.168.2.0/24 -j ACCEPT`  
  `iptables -A OUTPUT -d 192.168.2.0/24 -j REJECT`  

![](capturas/fire13.png)

> Vemos que no podemos acceder a mynet por ningún puerto excepto por el 22 de ssh.

## __Ejemplo 03: `ip-03-established.sh`__  
Conceptos del estado:  
`--state — coincide un paquete con los siguientes estados de conexión:`  
+ ESTABLISHED: El paquete seleccionado se asocia con otros paquetes en una conexión establecida.
+ INVALID: El paquete seleccionado no puede ser asociado a una conexión conocida.
+ NEW: El paquete seleccionado o bien está creando una nueva conexión o bien forma parte de una conexión de dos caminos que antes no había sido vista.
+ RELATED: El paquete seleccionado está iniciando una nueva conexión en algún punto de la conexión existente.  

En este ejemplo trabajamos para ver la diferencia en no permitir un host acceder a los servicios web externos (reglas OUTPUT) y en permitir el tráfico exterior al servidor web del propio host y permitir que este servidor emita respuestas http a los clientes (reglas INPUT). También tener en cuenta que para permitir el tráfico de respuesta será una regla OUTPUT.  

[script ip-03-established.sh](practica4/ip-03-established.sh)  

#### __COMPROBACIONES__  
+ Permitir navegador por web (mala manera):  
  `iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT`  
  `iptables -A INPUT  -p tcp --sport 80 -j ACCEPT`  

![](capturas/fire14.png)  

![](capturas/fire15.png)  

> Acepto conexiones tanto de entrada como de salida por el puerto 80.  

+ Filtrar tráfico solo de respuesta:  
  `iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT`  
  `iptables -A INPUT  -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED  -j ACCEPT`  

![](capturas/fire18.png)  

> Aquí vemos el filtrado por wireshark de una conexión de salida del principal al host2  

![](capturas/fire19.png)  

> Aquí vemos el filtrado por wireshark de una conexión de entrada de net1 al principal

+ Ofrecer el servicio web, permitir solo respuestas a peticiones ya establecidas:  
  `iptables -A OUTPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT`     
  `iptables -A INPUT -p tcp --dport 80 -j ACCEPT`  

![](capturas/firewall10.png)  

> Aquí vemos el filtrado por wireshark de una conexión de salida de host2 al principal

![](capturas/fire20.png)  

> Aquí vemos el filtrado por wireshark de una conexión de entrada de host2 al principal

+ Ofrecer el servicio web a todos excepto a host2:  
  `iptables -A OUTPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT`  
  `iptables -A INPUT -p tcp --dport 80 -s 192.168.1.44 -j REJECT`  
  `iptables -A INPUT -p tcp --dport 80 -j ACCEPT`  

![](capturas/fire16.png)  

![](capturas/fire17.png)  

![](capturas/firewall9.png)  

> Puedo establacer comunicaciones hacia fuera por el puerto 80, pero hacia dentro todos pueden excepto el host2

## __Ejemplo 04:`ip-04-icmp.sh`__
En este ejemplo utilizaremos unas reglas personalizadas para los pings que puede hacer o no nuestro ordenador principal respecto a diferentes casos configurados en iptables.  

[script ip-04-icmp.sh](practica4/ip-04-icmp.sh)  

#### __COMPROBACIONES__  
+ No permitir hacer pings al exterior:  
  `iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP`

![](capturas/fire3.png)  

> Vemos que no nos deja hacer pings de salida como por ejemplo google o al host2

+ No podemos hacer pings al host2:  
  `iptables -A OUTPUT -p icmp --icmp-type 8 -d 192.168.1.44 -j DROP`

![](capturas/fire4.png)  

> En este caso podemos hacer pings al exterior como por ejemplo google pero hemos rechazado hacer al host2

+ No permitimos responder a los pings que nos hagan:    
  `iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP`

![](capturas/firewall6.png)  

> Establecemos la regla de que no nos puedan hacer ping, con la opción de DROP en la que se les agotará el tiempo sin dar un código de error antes, como sí que haría con REJECT

+ No aceptamos recibir respuestas de ping:  
  `iptables -A INPUT -p icmp --icmp-type 0 -j DROP`

![](capturas/fire5.png)  

> Regla para que no podamos recibir respuesta de los pings que hagamos al exterior

## __Ejemplo 05: `ip-05.nat.sh`__
En este ejemplo vemos el concepto de NAT, el cual hacemos que un host actue como router activando el bit de forwading.

[script ip-05-nat.sh](practica4/ip-05-nat.sh)  

Para activar NAT en nuestro host principal para que las redes internas privadas puedan salir al exterior:  
```
[root@miguel firewalls]# echo 1 > /proc/sys/net/ipv4/ip_forward
[root@miguel firewalls]# cat /proc/sys/net/ipv4/ip_forward
1
```

#### __COMPROBACIONES__  

+ Creamos dos redes internas con docker:  
```
[isx46410800@miguel ~]$ docker network create netA
ae2000b70614f635956dbb49771fcb398de25efc36313bc14989d830b24df036
[isx46410800@miguel ~]$ docker network create netB
a2577e8c47a940c98507cd05019f38e36f514f202ef34a50cfc5aea77bfa527e
[isx46410800@miguel ~]$ docker network create netZ
497a82c6b1c83c88e8e5a69c73728411c39c858adba41011e54edb365a67ee8a
```

+ Encendemos en cada red (netA y netB) dos hosts:  
```
[isx46410800@miguel ~]$ docker run --rm --name hostA1 -h hostA1 --net netA --privileged -d isx46410800/firewalls:net19
1ee450755d3cffc0fbf9c037d7f38fcf0bfb243336bcd728010e765ecaf1d522
[isx46410800@miguel ~]$ docker run --rm --name hostA2 -h hostA2 --net netA --privileged -d isx46410800/firewalls:net19
e62d644808dab64a6787fc2fbdb131482d385ed42e0523792e974ff6ad70ab75
[isx46410800@miguel ~]$ docker run --rm --name hostB1 -h hostB1 --net netB --privileged -d isx46410800/firewalls:net19
cb73604669c50b8cbe63740d17675f8cda011331fb3d5da21a6d70dc1b27b8aa
[isx46410800@miguel ~]$ docker run --rm --name hostB2 -h hostB2 --net netB --privileged -d isx46410800/firewalls:net19
d9f54d44aa59fef8cc9963b41fb99d2ebaced2565340e70b892ce3b869403b6e
[script ip-05.nat.sh](practica4/ip-05.nat.sh)  
```

+  Vemos que está encendido todo correctamente:  
```
[isx46410800@miguel ~]$ docker ps
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS               NAMES
d9f54d44aa59        isx46410800/firewalls:net19   "/opt/docker/startup…"   2 minutes ago       Up 2 minutes                            hostB2
cb73604669c5        isx46410800/firewalls:net19   "/opt/docker/startup…"   2 minutes ago       Up 2 minutes                            hostB1
e62d644808da        isx46410800/firewalls:net19   "/opt/docker/startup…"   2 minutes ago       Up 2 minutes                            hostA2
1ee450755d3c        isx46410800/firewalls:net19   "/opt/docker/startup…"   3 minutes ago       Up 3 minutes                            hostA1
```

+ Vemos las IPs de cada host y red:  
```
[isx46410800@miguel ~]$ docker network inspect netA
HOSTA1: 172.18.0.2/16
HOSTA2: 172.18.0.3/16
```
```
[isx46410800@miguel ~]$ docker network inspect netB
HOSTB1: 172.19.0.2/16
HOSTB2: 172.19.0.3/16
```

+ Comprobamos conexión al exterior:  

![](capturas/fire21.png)  
> Vemos que el HOSTA1 de la red netA tiene conexión al exterior con host2 y 8.8.8.8

![](capturas/fire22.png)  
> Vemos que el HOSTB1 de la red netB tiene conexión al exterior con host2 y 8.8.8.8

+ Eliminamos las reglas con ip-default.sh pero cambiamos el bit de forwading en el script a 0:
`echo 0 > /proc/sys/net/ipv4/ip_forward`  
```
[root@miguel firewalls]# ./ip-default.sh
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
Chain DOCKER (0 references)
target     prot opt source               destination         
[root@miguel firewalls]# cat /proc/sys/net/ipv4/ip_forward
0
```
> Con esto hacemos que nuestro host principal ya no actue como router, por lo tanto ya no puede enmascarar las ips de las redes internas privadas para que puedan salir al exterior y comunicarse tanto con la red local de mi casa como por ejemplo a google (8.8.8.8)

+ Comprobamos conexión al exterior:  

![](capturas/fire23.png)  
> Vemos que el HOSTA1 de la red netA no tiene conexión al exterior con host2 y 8.8.8.8

![](capturas/fire24.png)  
> Vemos que el HOSTB1 de la red netB no tiene conexión al exterior con host2 y 8.8.8.8

+ Ahora ejecutamos el script de [script ip-05-nat.sh](practica4/ip-05-nat.sh) y probamos de nuevo la conexión:  
> Vemos que en el script volvemos a activar el bit de forwading, haciendo que actue como router de nuevo, abrimos nuestra interfície y enmascaramos las ips de las redes internas privadas a nuestra interficie para que se pueda comunicar al exterior(enp4s0)

![](capturas/fire25.png)  
> Vemos que el HOSTA1 de la red netA tiene de nuevo conexión al exterior con host2 y 8.8.8.8

![](capturas/fire26.png)  
> Vemos que el HOSTB1 de la red netB tiene de nuevo conexión al exterior con host2 y 8.8.8.8

## __Ejemplo 06:__

#### __COMPROBACIONES__  

## __Ejemplo 07:__

#### __COMPROBACIONES__  

## __Ejemplo 08:__

#### __COMPROBACIONES__  

## __Ejemplo 09:__

#### __COMPROBACIONES__  

## __Ejemplo 10:__

#### __COMPROBACIONES__  

## __Ejemplo 11:__

#### __COMPROBACIONES__  
