#!/bin/sh

# install Python 3.9 ------------------------------------------------------------------------------
yum install -y \
        readline-devel.x86_64

[ $1 -lt 7 ] && source scl_source enable devtoolset-2 2>/dev/null || echo GCC 4.8 enabled

pythonTag=Python-3.8.2
pythonPkg=${pythonTag}.tgz
pythonUrl=https://www.python.org/ftp/python/3.8.2/$pythonPkg

wget --no-check-certificate -O /root/$pythonPkg $pythonUrl \
        && cd /root && tar xvf /root/$pythonPkg \
        && cd $pythonTag \
        && ./configure --enable-shared --enable-unicode=ucs4 --enable-optimizations \
        && gmake altinstall -j \
        && cd /root && rm -rf /root/$pythonTag /root/$pythonPkg

yum remove -y \
        readline-devel.x86_64

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
python3.8 -m ensurepip
python3.8 -m pip install --upgrade pip
python3.8 -m pip install numpy
python3.8 -m pip install sphinx breathe

# Add symlink
ln -s /usr/local/bin/python3.8 /usr/local/bin/python
ln -s /usr/local/bin/python3.8 /usr/local/bin/python3
