# <u>__PRÁCTICA 4 - FIREWALLS__</u>

## __IPs__
+ __IP host principal:__ 192.168.1.104  
+ __IP host 2:__ 192.168.1.44  
+ __IP dockers:__ 172.19.0.2  / 172.19.0.3 / 172.19.0.4  
`[isx46410800@miguel firewalls]$ docker run --rm --name net1 -h net1 --net mynet -d isx46410800/net19:nethost`  
`[isx46410800@miguel firewalls]$ docker run --rm --name net2 -h net2 --net mynet -d isx46410800/net19:nethost`  
`[isx46410800@miguel firewalls]$ docker run --rm --name net3 -h net3 --net mynet -d isx46410800/net19:nethost`  

## __Ejemplo Inicial: `ip-default.sh`__
En este ejemplo borramos todas las reglas actuales, establecemos una politica por defecto de todo abierto, permite todo el tráfico de entrada/salida en loopback y en nuestra IP host local. (Igualmente por defecto la politica por defecto ACCEPT ya lo hacía).

[script ip-default.sh](practica4/ip-default.sh)

![](capturas/fire1)

#### __COMPROBACIONES__  


## __Ejemplo 01:__

#### __COMPROBACIONES__  

## __Ejemplo 02:__

#### __COMPROBACIONES__  

## __Ejemplo 03:__

#### __COMPROBACIONES__  

## __Ejemplo 04:__

#### __COMPROBACIONES__  

## __Ejemplo 05:__

#### __COMPROBACIONES__  

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
