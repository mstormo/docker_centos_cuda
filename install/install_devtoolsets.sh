#!/bin/sh

# install devtoolsets -----------------------------------------------------------------------------
case "$1" in
        7)  # add devtoolset 4
                yum install -y centos-release-scl
                yum update -y
                yum install -y \
                        devtoolset-4-runtime \
                        devtoolset-4-binutils \
                        devtoolset-4-gdb \
                        devtoolset-4-gcc \
                        devtoolset-4-gcc-c++ \
                        devtoolset-4-valgrind \
                        devtoolset-4-strace
                /usr/sbin/alternatives --altdir /opt/rh/devtoolset-4/root/etc/alternatives --admindir /opt/rh/devtoolset-4/root/var/lib/alternatives --set ld /opt/rh/devtoolset-4/root/usr/bin/ld.gold                                                
                ;;
esac

case "$1" in
        7|6)# add devtoolset 3
                yum install -y centos-release-scl
                yum update -y
                yum install -y \
                        devtoolset-3-runtime \
                        devtoolset-3-binutils \
                        devtoolset-3-gdb \
                        devtoolset-3-gcc \
                        devtoolset-3-gcc-c++ \
                        devtoolset-3-valgrind \
                        devtoolset-3-strace
                /usr/sbin/alternatives --altdir /opt/rh/devtoolset-3/root/etc/alternatives --admindir /opt/rh/devtoolset-3/root/var/lib/alternatives --set ld /opt/rh/devtoolset-3/root/usr/bin/ld.gold                        
                ;;
esac

case "$1" in
        6|5)# add devtoolset 2 (gcc 4.8) repo
                wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
                yum update -y
                yum install -y \
                        devtoolset-2-runtime \
                        devtoolset-2-binutils \
                        devtoolset-2-gdb \
                        devtoolset-2-gcc \
                        devtoolset-2-gcc-c++ \
                        devtoolset-2-valgrind \
                        devtoolset-2-strace
                /usr/sbin/alternatives --altdir /opt/rh/devtoolset-2/root/etc/alternatives --admindir /opt/rh/devtoolset-2/root/var/lib/alternatives --set ld /opt/rh/devtoolset-2/root/usr/bin/ld.gold
                ;;
esac
