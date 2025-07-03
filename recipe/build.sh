#!/bin/bash

export C_INCLUDE_PATH=${PREFIX}/include
export LDFLAGS="-L${PREFIX}/lib"
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig

if [ "$target_platform" != "win-64" ]; then
  rm ./config.sub
  ./autogen.sh
fi

# -fforce-addr is not supported in clang
if [ `uname` == Darwin ]; then
    sed -i.bak 's/-fforce-addr //g' ./configure
    sed -i.bak 's/-fforce-addr //g' ./configure.ac
    export LDFLAGS="${LDFLAGS} -Wl,-rpath,$PREFIX/lib"
fi

export CONFIGURE_ADDITIONAL_OPTIONS=""

if [ "$target_platform" == "win-64" ]; then
  # GCC style assembly is not supported by clang on Windows, so let's disable it for now
  # if you really need the fastest possible libtheora on Windows, feel free to open an issue
  export CONFIGURE_ADDITIONAL_OPTIONS="$CONFIGURE_ADDITIONAL_OPTIONS --disable-asm"
fi

./configure --prefix=${PREFIX} --disable-examples --disable-spec ${CONFIGURE_ADDITIONAL_OPTIONS}

# As documented in https://github.com/conda-forge/autotools_clang_conda-feedstock/blob/cb241060f5d8adcd105f3b2e8454a8ad4d70f08f/recipe/meta.yaml#L58C1-L58C60
[[ "$target_platform" == "win-64" ]] && patch_libtool

make

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
    make check
fi

make install

# Delete static libraries (per CFEP-18)
rm -rf $PREFIX/lib/libtheor*.a

# Delete docs
rm -rf $PREFIX/share/doc/libtheor*
