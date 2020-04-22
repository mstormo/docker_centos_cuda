#!/bin/sh

curldev=libcurl-devel.x86_64
[ $1 -eq 5 ] && curldev=curl-devel.x86_64

openssldev=openssl-devel.x86_64
[ $1 -eq 5 ] && openssldev="openssl1-devel-1.0.1e-57 wget-1.12-8.1.el5_11 --exclude=\"openssl-devel-0.9.8e-40.el5_11.1\""

# install GIT to a recent version -----------------------------------------------------------------
yum install -y -t --nogpgcheck \
        $curldev \
        expat-devel.x86_64 \
        gettext-devel.x86_64 \
        $openssldev

[ $1 -lt 7 ] && source scl_source enable devtoolset-2 2>/dev/null || echo GCC 4.8 enabled

git_version=2.9.3
gitTag=git-${git_version}
gitPkg=git-v${git_version}.tar.gz
gitUrl=https://codeload.github.com/git/git/tar.gz/v$git_version

wget --no-check-certificate -O /root/$gitPkg $gitUrl \
        && cd /root && tar xvf /root/$gitPkg \
        && cd $gitTag && gmake prefix=/usr/local install -j \
        && cd /root && rm -rf /root/$gitTag /root/$gitPkg

yum remove -y \
        gettext-devel
