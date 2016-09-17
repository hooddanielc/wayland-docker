set -e
. $HOME/.config/wayland-build-tools/wl_defines.sh
cd $WLROOT/$1

make -j32 && make install
if [ $? != 0 ]; then
  echo "Build Error.  Terminating"
  exit 1
fi
