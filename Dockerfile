FROM centos:5
#FROM centos:6
#FROM centos:7
LABEL Description="CentOS with various CUDA versions for quick build of producs based on customer configuration"
MAINTAINER Marius Storm-Olsen <mstormo@gmail.com>

# Use /data as the persistant storage for seismic
VOLUME ["/data"]

# Install the development tools needed (glibc.i686 needed for cmake on CentOS >= 6)
RUN yum groupinstall -y "Development Tools" \
    && yum install -y \
           curl \
           libjpeg-devel \
           libpng-devel \
           zlib-devel \
           freetype-devel \
           fontconfig-devel \
           mesa-libGL-devel \
           freeglut-devel \
           redhat-lsb \
           qt-devel \
           glibc.i686 \
    && curl -o  /root/cmake-2.8.12.2-Linux-i386.tar.gz http://www.cmake.org/files/v2.8/cmake-2.8.12.2-Linux-i386.tar.gz \
    && tar zxf /root/cmake-2.8.12.2-Linux-i386.tar.gz -C /root \
    && cp -R /root/cmake-2.8.12.2-Linux-i386/* /usr/local/ \
    && rm -rf /root/cmake-2.8.12.2-Linux-i386* \
    && yum clean all \
    && rm -rf /tmp/*

# Install GIT to a recent version, or our cmake will break on CentOS >=6
RUN yum install -y \
        curl-devel \
        expat-devel \
        gettext-devel \
        openssl-devel \
    && curl -o /root/git-v2.5.1.tar.gz https://codeload.github.com/git/git/tar.gz/v2.5.1 \
    && cd /root && tar zxf /root/git-v2.5.1.tar.gz \
    && make prefix=/usr/local -C /root/git-2.5.1 install \
    && rm -rf /root/git-2.5.1* /root/git-v2.5.1.tar.gz \
    && yum remove -y \
        curl-devel \
        gettext-devel \
    && rm -rf /tmp/*

# CUDA 4.2 - Uses its own install implementation, due to different packaging
#ENV cudaPkg cudatoolkit_4.2.9_linux_64_rhel5.5.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/$cudaPkg
#ENV cudaLoc /usr/local/cuda
#RUN curl -o /root/$cudaPkg $cudaUrl \
#    && chmod 755 /root/$cudaPkg \
#    && /root/$cudaPkg -- --prefix=/usr/local auto \
#    && rm -rf /root/$cudaPkg $cudaLoc/doc $cudaLoc/libnvvp $cudaLoc/bin/nvvp

# CUDA 5.0
#ENV cudaPkg cuda_5.0.35_linux_64_rhel5.x-1.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/5_0/rel-update-1/installers/$cudaPkg
#ENV cudaLoc /usr/local/cuda-5.0

# CUDA 5.5
#ENV cudaPkg cuda_5.5.22_linux_64.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/$cudaPkg
#ENV cudaLoc /usr/local/cuda-5.5

# CUDA 6.0
#ENV cudaPkg cuda_6.0.37_linux_64.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/$cudaPkg
#ENV cudaLoc /usr/local/cuda-6.0

# CUDA 6.5
ENV cudaPkg cuda_6.5.14_linux_64.run
ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/$cudaPkg
ENV cudaLoc /usr/local/cuda-6.5

# CUDA 7.0
#ENV cudaPkg cuda_7.0.28_linux.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/$cudaPkg
#ENV cudaLoc /usr/local/cuda-7.0

# CUDA 7.5
#ENV cudaPkg cuda_7.5.18_linux.run
#ENV cudaUrl http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/$cudaPkg
#ENV cudaLoc /usr/local/cuda-7.5

# Install CUDA, general implementation for all but 4.2
# Also remove doc,samples,nvvp to save some space
RUN curl -o /root/$cudaPkg $cudaUrl \
    && chmod 755 /root/$cudaPkg \
    && /root/$cudaPkg --silent --toolkit --override \
    && rm -rf /root/$cudaPkg \
    && rm -rf $cudaLoc/doc $cudaLoc/jre $cudaLoc/libnsight $cudaLoc/libnvvp $cudaLoc/bin/nvvp $cudaLoc/samples

# Add CUDA to ld.so.conf
RUN echo $cudaLoc/lib64 >> /etc/ld.so.conf \
    && echo $cudaLoc/lib >> /etc/ld.so.conf \
    && ldconfig

# Use an entrypoint which ensures commands happen with user permissions
COPY root.bashrc /root/root.bashrc
COPY user.bashrc /root/user.bashrc
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
