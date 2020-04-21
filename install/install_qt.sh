#!/bin/sh

# clean slate, remove any Qt repo
yum list installed | grep qt | cut -d' ' -f1 | xargs rpm -e --nodeps
yum update

qtLibDeps="\
        bash.x86_64 \
        glibc.x86_64 \
        libgcc.x86_64 \
        libICE-devel.x86_64 \
        libjpeg-turbo-devel.x86_64 \
        libjpeg-devel.x86_64 \
        libpng-devel.x86_64 \
        libSM-devel.x86_64 \
        libstdc++.x86_64 \
        libX11-devel.x86_64 \
        libXcursor-devel.x86_64 \
        libXext-devel.x86_64 \
        libXfixes-devel.x86_64 \
        libXft-devel.x86_64 \
        libXi-devel.x86_64 \
        libXinerama-devel.x86_64 \
        libXrandr-devel.x86_64 \
        libXrender-devel.x86_64 \
        libXrender-devel.x86_64 \
        libXt-devel.x86_64 \
        mesa-libGL-devel.x86_64 \
        mesa-libGLU-devel.x86_64 \
        pkgconfig.x86_64 \
        xorg-x11-proto-devel.noarch \
        xorg-x11-proto-devel.x86_64 \
        zlib-devel.x86_64"

smDevelLib=
[ $1 -eq 6 ] && smDevelLib=libSM-devel

yum install -y \
        $qtLibDeps \
        $smDevelLib

# make sure we use gcc/g++ 4.8 for building
[ $1 -lt 7 ] && source scl_source enable devtoolset-2 2>/dev/null || echo GCC 4.8 enabled

# Qt 4.8.x ----------------------------------------------------------------------------------------
case "download" in
    "build")
        qtTag=qt-everywhere-opensource-src-4.8.7
        qtPkg=${qtTag}.tar.gz
        qtUrl=https://download.qt.io/official_releases/qt/4.8/4.8.7/$qtPkg

        wget --no-check-certificate -O /root/$qtPkg $qtUrl \
                && cd /root && tar xvf /root/$qtPkg \
                && cd $qtTag \
                && ./configure -fast -opensource -confirm-license -nomake demos -nomake examples \
                               -nomake docs -nomake translations -optimized-qmake \
                               -prefix /usr/lib64/qt4 -bindir /usr/lib64/qt4/bin -datadir /usr/lib64/qt4 \
                               -docdir /usr/share/doc/qt4 -headerdir /usr/include -libdir /usr/lib64 \
                               -plugindir /usr/lib64/qt4/plugins -sysconfdir /etc \
                               -translationdir /usr/share/qt4/translations -no-rpath -reduce-relocations \
                               -no-separate-debug-info -no-phonon -no-gstreamer -sm -stl -no-webkit \
                && gmake install \
                && cd /root && rm -rf /root/$qtTag /root/$qtPkg \
                && rm -rf /usr/share/doc/qt4
        ## Alternatively
        # create a package which we can simply download and untar
        #INSTALL_ROOT=/builds make install
        #tar -C /builds/ -c . | xz -9 -c - > /data/centos${1}_${qtTag}.tar.xz
        ;;
    "download")
        qtTag=qt-everywhere-opensource-src-4.8.7
        qtPkg=centos${1}_${qtTag}.tar.xz
        qtUrl=https://raw.githubusercontent.com/mstormo/centos_binaries/master/qt/$qtPkg

        wget --no-check-certificate -O /root/$qtPkg $qtUrl \
                && xz -dc /root/$qtPkg | tar xf - -C / \
                && rm -rf /root/$qtPkg /usr/share/doc/qt4
        ;;
esac

pushd /usr/lib64/qt4/bin
for i in * ; do
    case "${i}" in
        assistant|designer|linguist|lrelease|lupdate|moc|qmake|qtconfig|qtdemo|uic)
        mv $i ../../../bin/${i}-qt4
        ln -s ../../../bin/${i}-qt4 .
        ln -s ../../../bin/${i}-qt4 $i
        ;;
    *)
        mv $i ../../../bin/
        ln -s ../../../bin/$i .
        ;;
    esac
done
popd

/sbin/ldconfig


# Qt 5.7.x ----------------------------------------------------------------------------------------
# export PKG_CONFIG_PATH=/tmp/usr/lib/pkgconfig
#
# # setup Qt 5 dependencies
# xcbTag=xcb-proto-1.11
# xcbPkg=${xcbTag}.tar.gz
# xcbUrl=http://xcb.freedesktop.org/dist/$xcbPkg
#
# wget --no-check-certificate -O /root/$xcbPkg $xcbUrl \
# 	&& cd /root && tar xvf /root/$xcbPkg \
# 	&& cd $xcbTag && ./configure –prefix=/tmp/usr && gmake && gmake install \
# 	&& cd /root && rm -rf /root/$xcbPkg /root/$xcbPkg
#
# pthreadTag=libpthread-stubs-0.3
# pthreadPkg=${pthreadTag}.tar.gz
# pthreadUrl=http://xcb.freedesktop.org/dist/$pthreadPkg
#
# wget --no-check-certificate -O /root/$pthreadPkg $pthreadUrl \
# 	&& cd /root && tar xvf /root/$pthreadPkg \
# 	&& cd $pthreadTag && ./configure –prefix=/tmp/usr && gmake && gmake install \
# 	&& cd /root && rm -rf /root/$pthreadPkg /root/$pthreadPkg
#
# libxcbTag=libxcb-1.11
# libxcbPkg=${libxcbTag}.tar.gz
# libxcbUrl=http://xcb.freedesktop.org/dist/$libxcbPkg
#
# wget --no-check-certificate -O /root/$libxcbPkg $libxcbUrl \
# 	&& cd /root && tar xvf /root/$libxcbPkg \
# 	&& cd $libxcbTag && ./configure –prefix=/tmp/usr && gmake && gmake install \
# 	&& cd /root && rm -rf /root/$libxcbPkg /root/$libxcbPkg
#
# # build Qt 5
# qtTag=qt-everywhere-opensource-src-5.7.0
# qtPkg=${qtTag}.tar.gz
# qtUrl=https://download.qt.io/archive/qt/5.7/5.7.0/single/$qtPkg
#
# wget --no-check-certificate -O /root/$qtPkg $qtUrl \
# 	&& cd /root && tar xvf /root/$qtPkg \
# 	&& cd $qtTag && sed -i "s/#define QTESTLIB_USE_PERF_EVENTS/#undef QTESTLIB_USE_PERF_EVENTS/g" qtbase/src/testlib/qbenchmark_p.h \
# 	&& ./configure -R '\\\$$ORIGIN' -D _X_INLINE=inline -D XK_dead_currency=0xfe6f -D XK_ISO_Level5_Lock=0xfe13 -D FC_WEIGHT_EXTRABLACK=215 -D FC_WEIGHT_ULTRABLACK=FC_WEIGHT_EXTRABLACK -opensource -confirm-license -sysconfdir /etc/xdg -qt-xcb -no-xcb-xlib -nomake examples -nomake tests -no-dbus -no-icu -skip activeqt -skip androidextras -skip connectivity -skip location -skip macextras -skip multimedia -skip sensors -skip serialport -skip wayland -skip webchannel -skip webengine -skip websockets -skip winextras -skip x11extras \
# 	&& gmake && gmake install \
# 	&& cd /root && rm -rf /root/$qtTag /root/$qtPkg
