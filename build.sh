#!/bin/sh

cd `dirname $0` || exit 1

. ./cosp-android-common.sh || exit 1

export PREFIX ARCH

OUTDIR=$OUTDIR/taglib

CWD=`pwd`
mkdir -p $OUTDIR || exit 1
cd $OUTDIR || exit 1

CFLAGS="-O3 -fno-short-enums -fno-strict-aliasing"
CFLAGS="$CFLAGS -Wno-psabi -Wno-cast-qual -Wno-deprecated-declarations"
CXXFLAGS="-fexceptions -frtti"

LDFLAGS=""

case $ABI in
  armeabi)
    CFLAGS="$CFLAGS -march=armv5te"
    ;;
  armeabi-v7a)
    CFLAGS="$CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
    LDFLAGS="$LDFLAGS -Wl,--fix-cortex-a8"
    ;;
  *)
    ;;
esac

export CFLAGS CXXFLAGS LDFLAGS

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DWITH_MP4=ON \
  -DWITH_ASF=ON \
  -DCMAKE_SYSTEM_NAME=android \
  -DCMAKE_SYSTEM_PROCESSOR=$ABI \
  -DCMAKE_C_COMPILER=$TOOLCHAIN_PREFIX-gcc \
  -DCMAKE_CXX_COMPILER=$TOOLCHAIN_PREFIX-g++ \
  -DCMAKE_FIND_ROOT_PATH="$TOOLCHAIN_DIR/sysroot $PREFIX" \
  -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
  -DZLIB_LIBRARY=$TOOLCHAIN_DIR/sysroot/usr/lib/libz.so \
  -DZLIB_INCLUDE_DIR=$TOOLCHAIN_DIR/sysroot/usr/include \
  $CWD

make -j$BUILD_NUM_JOBS || exit 1
make install || exit 1

if [ "x$CUSTOM_OUTDIR" = "xno" ]; then
  rm -Rf $OUTDIR
fi

exit 0
