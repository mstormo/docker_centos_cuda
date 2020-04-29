#!/bin/sh

# install newer openssl for CentOS 5 --------------------------------------------------------------------

case "$1" in
        5)
                cd /tmp
                wget --no-check-certificate https://www.openssl.org/source/old/1.0.1/openssl-1.0.1u.tar.gz
                tar zxvf openssl-1.0.1u.tar.gz
                cd openssl-1.0.1u
                ./config -fpic shared && make && make install
                echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
                ldconfig
                ;;
esac
