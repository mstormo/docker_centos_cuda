OSname=`cat /etc/redhat-release | cut -d' ' -f1`
OSver=`cat /etc/redhat-release | sed -re 's/^[A-Za-z ]* ([0-9]+.[0-9]+).*$/\1/'`
CUver=`/usr/local/cuda/bin/nvcc --version | grep release | cut -d' ' -f5 | cut -d',' -f1`

PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;33m\]$OSname $OSver Cuda $CUver \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
