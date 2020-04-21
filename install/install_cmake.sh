#!/bin/sh

# install cmake 2.8 -------------------------------------------------------------------------------
#cmake_ver=cmake28
#[ $1 -eq 7 ] && cmake_ver=cmake # package is just called cmake in centos 7

#yum install -y \
#        $cmake_ver

# only symlink cmake on CentOS 5
#[ $1 -eq 5 ] && ln -s /usr/bin/cmake28 /usr/bin/cmake || echo Not symlinking cmake28, CentOS > 5

# install cmake 3.9.0 -----------------------------------------------------------------------------

curldev=libcurl-devel.x86_64
[ $1 -eq 5 ] && curldev=curl-devel.x86_64

yum install -y \
        $curldev \
        ncurses-devel

cd /tmp
git clone https://github.com/Kitware/CMake.git
cd CMake
git checkout tags/v3.17.1
./bootstrap --prefix=/usr && make && make install
cd / && rm -rf /tmp/CMake

yum remove -y \
        $curldev \
        ncurses-devel
