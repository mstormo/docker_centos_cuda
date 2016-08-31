#!/bin/sh

os_ver=$1
cuda_ver=$2

yum update -y

/root/install/install_packages.sh     	$os_ver
/root/install/install_devtoolsets.sh  	$os_ver

# make sure we use gcc/g++ 4.8 for building here on out
source scl_source enable devtoolset-2 >/dev/null 2>&1 || echo GCC 4.8 enabled

/root/install/install_ccache.sh			$os_ver
/root/install/install_cmake.sh			$os_ver
/root/install/install_subversion.sh		$os_ver
/root/install/install_git.sh			$os_ver
/root/install/install_python27.sh		$os_ver
/root/install/install_openssh.sh		$os_ver
/root/install/install_cuda.sh 			$cuda_ver
/root/install/install_qt.sh				$os_ver
		
# final cleanup of layer --------------------------------------------------------------------------
yum remove -y *.i?86
updatedb
yum clean all

rm -rf /root/.cache /tmp/*
