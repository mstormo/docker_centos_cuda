#!/bin/sh

# install Python 2.7 ------------------------------------------------------------------------------
yum install -y \
        python-setuptools \
        zlib-devel.x86_64 \
        readline-devel.x86_64 \
        openssl-devel.x86_64

source scl_source enable devtoolset-2 >/dev/null 2>&1 || echo GCC 4.8 enabled

pythonTag=Python-2.7.12
pythonPkg=${pythonTag}.tgz
pythonUrl=http://www.python.org/ftp/python/2.7.12/$pythonPkg

wget --no-check-certificate -O /root/$pythonPkg $pythonUrl \
        && cd /root && tar xvf /root/$pythonPkg \
        && cd $pythonTag && ./configure && gmake altinstall \
        && cd /root && rm -rf /root/$pythonTag /root/$pythonPkg

yum remove -y \
        readline-devel.x86_64

python2.7 -m ensurepip
python2.7 -m pip install --upgrade pip
python2.7 -m pip install numpy

# Add symlink
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
