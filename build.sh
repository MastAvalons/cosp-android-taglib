#!/bin/sh

cd `dirname $0` || exit 1

. ./cosp-android-common.sh || exit 1

export PREFIX ARCH

CWD=`pwd`

CFLAGS="-O3 -fno-short-enums -fno-strict-aliasing"
CFLAGS="$CFLAGS -Wno-psabi -Wno-cast-qual -Wno-deprecated-declarations"
CXXFLAGS="-fexceptions -frtti -D__STDC_INT64__"

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

LDFLAGS="$LDFLAGS -lgnustl_shared -lcrystax_shared"

export CFLAGS CXXFLAGS LDFLAGS

CMAKE_PARAMS=""
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_INSTALL_PREFIX=$PREFIX"
CMAKE_PARAMS="$CMAKE_PARAMS -DWITH_MP4=ON"
CMAKE_PARAMS="$CMAKE_PARAMS -DWITH_ASF=ON"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_SYSTEM_NAME=android"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_SYSTEM_PROCESSOR=$ABI"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_C_COMPILER=$TOOLCHAIN_PREFIX-gcc"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_CXX_COMPILER=$TOOLCHAIN_PREFIX-g++"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_FIND_ROOT_PATH='$TOOLCHAIN_DIR/sysroot $PREFIX'"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY"
CMAKE_PARAMS="$CMAKE_PARAMS -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY"
CMAKE_PARAMS="$CMAKE_PARAMS -DZLIB_LIBRARY=$TOOLCHAIN_DIR/sysroot/usr/lib/libz.so"
CMAKE_PARAMS="$CMAKE_PARAMS -DZLIB_INCLUDE_DIR=$TOOLCHAIN_DIR/sysroot/usr/include"

OUTDIR=$OUTDIR/taglib/static
mkdir -p $OUTDIR || exit 1
cd $OUTDIR || exit 1

cmake $CMAKE_PARAMS -DENABLE_STATIC=ON $CWD || exit 1
make -j$BUILD_NUM_JOBS || exit 1
make install || exit 1

if [ "x$CUSTOM_OUTDIR" = "xno" ]; then
  rm -Rf $OUTDIR
fi

OUTDIR=$OUTDIR/taglib/shared
mkdir -p $OUTDIR || exit 1
cd $OUTDIR || exit 1

cmake $CMAKE_PARAMS -DENABLE_STATIC=OFF $CWD || exit 1
make -j$BUILD_NUM_JOBS || exit 1
make install || exit 1

if [ "x$CUSTOM_OUTDIR" = "xno" ]; then
  rm -Rf $OUTDIR
fi

exit 0
