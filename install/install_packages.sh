#!/bin/sh

# avoid 32-bit packages, if possible
echo multilib_policy=best >> /etc/yum.conf

yum groupinstall -y "Development Tools"

yum install -y \
           curl \
		   wget \
		   nano \
		   sudo \
		   ncdu \
		   strace \
		   screen \
		   mlocate \
           glibc.i686 \
           zlib-devel \
           redhat-lsb \
           libpng-devel \
		   vim-enhanced \
           libjpeg-devel \
           freeglut-devel \
           freetype-devel \
           fontconfig-devel \
           mesa-libGL-devel

# setup EPEL repo for given CentOS version --------------------------------------------------------
cd /root && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-${1}.noarch.rpm
rpm -Uvhi /root/epel-release-latest-${1}.noarch.rpm
rm /root/epel-release-latest-${1}.noarch.rpm
