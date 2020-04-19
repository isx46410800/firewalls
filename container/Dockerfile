FROM fedora:27
LABEL author="@Miguel Amoros ASIX M11-SAD"
LABEL description="SSH Server Curs 2019-2020"
RUN dnf -y install xinetd iproute iputils nmap uw-imap procps net-tools passwd httpd vsftpd openssh-server tftp-server telnet ftp openssh-clients vim tree 
RUN mkdir /opt/docker
#RUN mkdir /opt/docker/xinetd.d
#COPY xinetd.d/* /opt/docker/xinetd.d/
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh /opt/docker/install.sh
WORKDIR /opt/docker
CMD [ "/opt/docker/startup.sh" ]
