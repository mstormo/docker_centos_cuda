#!/bin/sh

os_ver=$1
cuda_ver=$2

source /root/install/utils.sh
now build_start

now packages_start
/root/install/install_packages.sh     	$os_ver
now packages_stop
echo_total packages_start packages_stop Basic packages installed!

now devtools_start
/root/install/install_devtoolsets.sh  	$os_ver
now devtools_stop
echo_total devtools_start devtools_stop Devtoolset installed!

# make sure we use gcc/g++ 4.8 for building here on out
source scl_source enable devtoolset-2 >/dev/null 2>&1 || echo GCC 4.8 enabled

now ccache_start
/root/install/install_ccache.sh			$os_ver
now ccache_stop
echo_total ccache_start ccache_stop Ccache installed!

now git_start
/root/install/install_git.sh			$os_ver
now git_stop
echo_total git_start git_stop Git built and installed!

now cmake_start
/root/install/install_cmake.sh			$os_ver
now cmake_stop
echo_total cmake_start cmake_stop Cmake installed!

now svn_start
/root/install/install_subversion.sh		$os_ver
now svn_stop
echo_total svn_start svn_stop Subversion installed!

now python_start
/root/install/install_python27.sh		$os_ver
now python_stop
echo_total python_start python_stop Python 2.7 built and installed!

now openssh_start
/root/install/install_openssh.sh		$os_ver
now openssh_stop
echo_total openssh_start openssh_stop OpenSSH Server installed!

now cuda_start
/root/install/install_cuda.sh 			$cuda_ver
now cuda_stop
echo_total cuda_start cuda_stop Cuda $cuda_ver installed!

now qt_start
/root/install/install_qt.sh			$os_ver
now qt_stop
echo_total qt_start qt_stop Qt built and installed!
		
# final cleanup of layer --------------------------------------------------------------------------
yum remove -y *.i?86
updatedb
yum clean all

rm -rf /root/.cache /tmp/*

echo ===================================================
echo Docker image parts build times:
echo_total packages_start packages_stop Basic packages
echo_total devtools_start devtools_stop Devtoolset
echo_total ccache_start ccache_stop Ccache
echo_total cmake_start cmake_stop Cmake
echo_total svn_start svn_stop Subversion
echo_total git_start git_stop Git
echo_total python_start python_stop Python 2.7
echo_total openssh_start openssh_stop OpenSSH Server
echo_total cuda_start cuda_stop Cuda $cuda_ver
echo_total qt_start qt_stop Qt
echo ===================================================
echo_elapsed build_start Docker build process completed!
