OSname=`cat /etc/redhat-release | cut -d' ' -f1`
OSver=`cat /etc/redhat-release | sed -re 's/^[A-Za-z ]* ([0-9]+.[0-9]+).*$/\1/'`
CUver=`/usr/local/cuda/bin/nvcc --version | grep release | cut -d' ' -f5 | cut -d',' -f1`

eval $(dircolors -b $HOME/.dircolors)

PS1='\[\e[0;31m\]\u@\h\[\e[m\] \[\e[1;33m\]$OSname $OSver Cuda $CUver \[\e[0;38;5;30m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

# set CCACHE directory to (assumingly) persistent storage
export CCACHE_DIR=/builds/ccache
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# use devtoolset-2 as default, ignoring failure
source scl_source enable devtoolset-2 >/dev/null 2>&1

alias ls='ls --color=auto'
alias ll='ls -la'
