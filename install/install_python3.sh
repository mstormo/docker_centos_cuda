#!/bin/sh

# no Python 3 on CentOS 5
[ $1 -eq 5 ] && exit 0

case "$1" in
        8)  # install distro python3 package
                yum install -y \
                        python3
                ;;
        *) # install Python 3.8 manually
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

                # Add symlink
                ln -s /usr/local/bin/python3.8 /usr/local/bin/python3
                ;;
esac

# make python3 the default python interpreter
alternatives --set python /usr/local/bin/python3

python3 -m ensurepip
python3 -m pip install --upgrade pip
python3 -m pip install numpy
python3 -m pip install sphinx breathe
