set -e
. $HOME/.config/wayland-build-tools/wl_defines.sh

pkg=$1
shift
echo
echo $pkg
cd $WLROOT/$pkg
echo "./autogen.sh --prefix=$WLD $*"
./autogen.sh --prefix=$WLD $*
