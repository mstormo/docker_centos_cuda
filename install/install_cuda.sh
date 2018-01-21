#!/bin/sh

source /root/install/utils.sh
now cuda_build_start

source scl_source enable devtoolset-2 >/dev/null 2>&1 || echo GCC 4.8 enabled

case "cuda-$1" in
        cuda-4.2)
                # CUDA 4.2 - Uses its own install implementation, due to different packaging
                cudaPkg=cudatoolkit_4.2.9_linux_64_rhel5.5.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/$cudaPkg
                cudaLoc=/usr/local/cuda

                echo $(date +%T) - Downloading $cudaPkg...
                curl -sS -o /root/$cudaPkg $cudaUrl
                chmod 755 /root/$cudaPkg

                echo $(date +%T) - Installing $cudaPkg...
                /root/$cudaPkg -- --prefix=/usr/local auto || (echo Cuda installation failed!! && exit 1)

                echo $(date +%T) - Cleaning up $cudaPkg, and removing non-important parts
                rm -rvf /root/$cudaPkg $cudaLoc/doc $cudaLoc/libnvvp $cudaLoc/bin/nvvp $cudaLoc/lib/*_static.a $cudaLoc/lib64/*_static.a

                echo $(date +%T) - Updating ldconfig for Cuda...
                echo $cudaLoc/lib64 >> /etc/ld.so.conf
                echo $cudaLoc/lib >> /etc/ld.so.conf
                ldconfig
                exit $?
                ;;
        cuda-5.0)
                cudaPkg=cuda_5.0.35_linux_64_rhel5.x-1.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/5_0/rel-update-1/installers/$cudaPkg
                cudaRun=cudatoolkit_5.0.35_linux_64_rhel5.x.run
                ;;
        cuda-5.5)
                cudaPkg=cuda_5.5.22_linux_64.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/$cudaPkg
                cudaRun=cuda-linux64-rel-5.5.22-16488124.run
                ;;
        cuda-6.0)
                cudaPkg=cuda_6.0.37_linux_64.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/$cudaPkg
                cudaRun=cuda-linux64-rel-6.0.37-18176142.run
                ;;
        cuda-6.5)
                cudaPkg=cuda_6.5.14_linux_64.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/$cudaPkg
                cudaRun=cuda-linux64-rel-6.5.14-18749181.run
                ;;
        cuda-7.0)
                cudaPkg=cuda_7.0.28_linux.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/$cudaPkg
                cudaRun=cuda-linux64-rel-7.0.28-19326674.run
                ;;
        cuda-7.5)
                cudaPkg=cuda_7.5.18_linux.run
                cudaUrl=http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/$cudaPkg
                cudaRun=cuda-linux64-rel-7.5.18-19867135.run
                ;;
        cuda-8.0)
                cudaPkg=cuda_8.0.61_375.26_linux.run
                cudaUrl=http://developer2.download.nvidia.com/compute/cuda/8.0/Prod2/local_installers/$cudaPkg
                cudaRun=
                ;;
        cuda-9.0)
                cudaPkg=cuda_9.0.176_384.81_linux.run
                cudaUrl=https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
                cudaRun=
                ;;
        cuda-9.1)
                cudaPkg=cuda_9.1.85_387.26_linux.run
                cudaUrl=https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux
                cudaRun=
                ;;
esac

cudaLoc=/usr/local/cuda-$1

# Install CUDA, general implementation for all but 4.2
# Also remove doc,samples,nvvp to save some space
echo $(date +%T) - Downloading $cudaPkg...
#curl -sS -o /root/$cudaPkg $cudaUrl
wget -nv -O /root/$cudaPkg $cudaUrl
chmod 755 /root/$cudaPkg
echo_elapsed cuda_build_start Cuda package downloaded!

# setting trap to ignore SIGTERM, since it's called by mistake in the script,
# due to a pipe to /dev/tty which is not accessible during docker build
trap '' 15

echo $(date +%T) - Installing $cudaPkg...
/root/$cudaPkg --silent --toolkit --override --verbose
echo_elapsed cuda_build_start Cuda package installed!

# remove signal trap
trap 15

echo $(date +%T) - Cleaning up $cudaPkg, and removing non-important parts
rm -rvf /root/$cudaPkg /tmp/*
rm -rvf $cudaLoc/doc $cudaLoc/jre $cudaLoc/libnsight $cudaLoc/libnvvp $cudaLoc/bin/nvvp $cudaLoc/samples $cudaLoc/lib/*_static.a $cudaLoc/lib64/*_static.a
echo_elapsed cuda_build_start Cuda cleanup done!

# Add CUDA to ld.so.conf
echo $(date +%T) - Updating ldconfig for Cuda...
echo $cudaLoc/lib64 >> /etc/ld.so.conf \
        && echo $cudaLoc/lib >> /etc/ld.so.conf \
        && ldconfig
echo_elapsed cuda_build_start Cuda libs added to ldconfig!

updatedb
yum clean all
