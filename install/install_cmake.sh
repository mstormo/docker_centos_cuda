#!/bin/sh

# # install standard cmake for CentOS 8
# case "$1" in
#         8)  # install distro python3 package
#                 yum install -y \
#                         cmake \
#                         cmake-doc
#                 ;;
# esac
# [ $1 -eq 8 ] && exit 0

# install cmake 3.17.1 -----------------------------------------------------------------------------

curldev=libcurl-devel.x86_64
[ $1 -eq 5 ] && curldev=curl-devel.x86_64

yum install -y \
        $curldev \
        ncurses-devel \
        openssl-devel.x86_64

[ $1 -lt 7 ] && source scl_source enable devtoolset-2 2>/dev/null || echo GCC 4.8 enabled

cmake_version=v3.17.1
[ $1 -eq 5 ] && cmake_version=v3.13.4

cd /tmp
git clone git://github.com/Kitware/CMake.git
cd CMake
git checkout tags/$cmake_version

./bootstrap --prefix=/usr && make -j && make install -j
cd / && rm -rf /tmp/CMake

yum remove -y \
        $curldev \
        ncurses-devel
