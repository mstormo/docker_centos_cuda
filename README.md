CentOS with various CUDAs to quickly build products custom to clients setup

These images may not be complete for others, but should provide a reasonable basis for customization.

Please note that most images are between 1.7GB and 2.4GB in size, due to sizable CUDA and Development Tools installations. But, this is rather negligible compared to a full dedicated VM sporting the same setup, and you'll compile **much** much faster! :-)

Volume ["/data"] is the mounting point for source code you wish to build. Normal execution will of course mount as root, but passing the UID from the host environment will create a user with the same UID, and execute with its permissions.

Example:

    docker run --rm -ti -e UID=$UID -v /my/sources/project:/data mstormo/centos_cuda /bin/bash
will mount /my/sources/project with my current user's permissions on CentOS 7 w/CUDA 7.5.

    docker run --rm -ti v /my/sources/project:/data mstormo/centos_cuda /bin/bash
will mount /my/sources/project with root permissions on CentOS 7 w/CUDA 7.5.

    docker run --rm -ti -e UID=$UID -v /my/sources/project:/data mstormo/centos_cuda:5_4.2 /bin/bash
will mount /my/sources/project with my current user's permissions on CentOS 5 w/CUDA 4.2.

**Tag** / **compressed** / **local**
**latest** / 875 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:latest.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:latest)
7_7.5 / 875 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_7.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_7.5)
7_7.0 / 841 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_7.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_7.0)
7_6.5 / 706 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_6.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_6.5)
7_6.0 / 770 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_6.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_6.0)
7_5.5 / 599 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_5.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_5.5)
7_5.0 / 533 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_5.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_5.0)
7_4.2 / 498 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:7_4.2.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:7_4.2)
6_7.5 / 947 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_7.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_7.5)
6_7.0 / 913 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_7.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_7.0)
6_6.5 / 777 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_6.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_6.5)
6_6.0 / 841 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_6.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_6.0)
6_5.5 / 671 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_5.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_5.5)
6_5.0 / 605 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_5.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_5.0)
6_4.2 / 569 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:6_4.2.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:6_4.2)
5_7.5 / 982 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_7.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_7.5)
5_7.0 / 948 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_7.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_7.0)
5_6.5 / 812 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_6.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_6.5)
5_6.0 / 876 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_6.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_6.0)
5_5.5 / 706 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_5.5.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_5.5)
5_5.0 / 640 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_5.0.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_5.0)
5_4.2 / 604 MB / [![](https://badge.imagelayers.io/mstormo/centos_cuda:5_4.2.svg)](https://imagelayers.io/?images=mstormo/centos_cuda:5_4.2)


