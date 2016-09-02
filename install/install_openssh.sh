#!/bin/sh

# install OpenSSH server for ssh login, if run as daemon ------------------------------------------
yum install -y \
	openssh-server

mkdir /var/run/sshd
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''

sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config
sed -i 's/UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed 's,session\s*required\s*pam_loginuid.so,session optional pam_loginuid.so,g' -i /etc/pam.d/sshd
