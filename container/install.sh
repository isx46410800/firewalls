#! /bin/bash
echo "@edt ASIX M11-SAD" > /var/www/html/index.html
echo "Benvinguts al vsftpd" > /var/ftp/hola.pdf
echo "directori public" > /var/ftp/pub/info.txt
echo "Benvingutts al servei tftp" > /var/lib/tftpboot/hola.txt
echo "llista de fitxers del tftp" > /var/lib/tftpboot/llista.txt
/usr/bin/ssh-keygen -A
touch /var/run/tftp.sock
cp /opt/docker/http-* /etc/xinetd.d/.
cp /opt/docker/daytime-* /etc/xinetd.d/.
cp /opt/docker/echo-* /etc/xinetd.d/.

