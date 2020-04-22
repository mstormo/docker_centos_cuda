#!/bin/sh

# install cmake 3.9.0 -----------------------------------------------------------------------------

curldev=libcurl-devel.x86_64
[ $1 -eq 5 ] && curldev=curl-devel.x86_64

yum install -y \
        $curldev \
        ncurses-devel

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
