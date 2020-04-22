#!/bin/sh

# install Python 2.7 ------------------------------------------------------------------------------
yum install -y \
        python-setuptools \
        zlib-devel.x86_64 \
        readline-devel.x86_64 \
        openssl-devel.x86_64

[ $1 -lt 7 ] && source scl_source enable devtoolset-2 2>/dev/null || echo GCC 4.8 enabled

pythonTag=Python-2.7.18
pythonPkg=${pythonTag}.tgz
pythonUrl=http://www.python.org/ftp/python/2.7.18/$pythonPkg

wget --no-check-certificate -O /root/$pythonPkg $pythonUrl \
        && cd /root && tar xvf /root/$pythonPkg \
        && cd $pythonTag \
        && ./configure --enable-shared --enable-unicode=ucs4 --enable-optimizations \
        && gmake altinstall -j \
        && cd /root && rm -rf /root/$pythonTag /root/$pythonPkg

yum remove -y \
        readline-devel.x86_64

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
python2.7 -m ensurepip
python2.7 -m pip install --upgrade pip
python2.7 -m pip install numpy

# Add symlink
# Make 3.x the default python distro
#ln -s /usr/local/bin/python2.7 /usr/local/bin/python
ln -s /usr/local/bin/python2.7 /usr/local/bin/python2
