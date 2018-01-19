#!/bin/sh

# avoid 32-bit packages, if possible
echo multilib_policy=best >> /etc/yum.conf

case "$1" in
    5)
        sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
        sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo
        sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/*.repo
        ;;
esac

yum update -y

yum groupinstall -y "Development Tools"

yum install -y \
        xz \
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
fedoraUrl=https://dl.fedoraproject.org/pub/epel
case "$1" in
    5)
        fedoraUrl=http://archives.fedoraproject.org/pub/archive/epel
        ;;
esac
cd /root && wget ${fedoraUrl}/epel-release-latest-${1}.noarch.rpm
rpm -Uvhi /root/epel-release-latest-${1}.noarch.rpm
rm /root/epel-release-latest-${1}.noarch.rpm
