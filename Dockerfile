FROM debian

ENV REPO_WAYLAND_BUILD_TOOLS https://github.com/hooddanielc/wayland-build-tools.git

RUN apt-get update
RUN apt-get install -y netselect-apt
RUN cd /etc/apt && netselect-apt
RUN apt-get update && apt-get install -y git-core sudo

RUN cd /tmp
RUN git clone $REPO_WAYLAND_BUILD_TOOLS /tmp/tools

WORKDIR /tmp/tool
ENV USER developer
ENV HOME /home/developer
ENV INCLUDE_XWAYLAND 1
ENV WLROOT $HOME/Wayland
ENV WLD $WLROOT/install
ENV WL_BITS 64
ENV DISTCHECK_CONFIGURE_FLAGS "--with-xserver-path=${WLROOT}/install/bin/Xwayland"

ENV LD_LIBRARY_PATH $WLD/lib
ENV PKG_CONFIG_PATH $WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
ENV PATH $WLD/bin:$PATH
ENV ACLOCAL_PATH "$WLD/share/aclocal"
ENV ACLOCAL "aclocal -I $ACLOCAL_PATH"

RUN mkdir -p $HOME/Wayland
RUN mkdir -p $HOME/.config/wayland-build-tools
RUN cp /tmp/tools/wl_defines.sh $HOME/.config/wayland-build-tools/

RUN sudo apt-get install -y autoconf automake bison debhelper dpkg-dev flex libtool
RUN sudo apt-get install -y pkg-config quilt python-libxml2

# WAYLAND DEPS
RUN sudo apt-get install -y xmlto \
  doxygen \
  graphviz \
  linux-libc-dev \
  libexpat1-dev \
  libmtdev-dev \
  libpam0g-dev \
  libunwind8-dev \
  libpciaccess-dev \
  libudev-dev \
  libgudev-1.0-dev \
  llvm-dev \
  python-mako \
  libxml2-dev \
  libpng-dev \
  libglib2.0-dev \
  libgcrypt20-dev \
  x11proto-scrnsaver-dev \
  libxfont-dev \
  libedit-dev \
  xfonts-utils \
  pciutils

# XWAYLAND DEPS
RUN sudo apt-get install -y libxcb-composite0-dev \
  x11proto-randr-dev \
  x11proto-composite-dev \
  x11proto-xinerama-dev \
  x11proto-dri2-dev \
  x11proto-gl-dev \
  xutils-dev \
  libxcursor-dev \
  libx11-dev \
  libx11-xcb-dev \
  libxdamage-dev \
  libxext-dev \
  libxfixes-dev \
  libxxf86vm-dev \
  xkb-data

ADD scripts/clone_or_update.sh /tmp/clone_or_update.sh

# WAYLAND DEPS
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/wayland/wayland
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/git/mesa/drm
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xcb/proto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/util/macros
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xcb/libxcb
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/presentproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/dri3proto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/lib/libxshmfence
RUN /tmp/clone_or_update.sh git://github.com/xkbcommon/libxkbcommon

RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/mesa/mesa

RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/pixman
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/cairo
RUN /tmp/clone_or_update.sh git://git.sv.gnu.org/libunwind
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/libevdev
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/wayland/wayland-protocols
RUN /tmp/clone_or_update.sh git://git.code.sf.net/p/linuxwacom/libwacom
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/wayland/libinput
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/wayland/weston

# XWAYLAND DEPS
RUN /tmp/clone_or_update.sh git://github.com/anholt/libepoxy
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/glproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/xproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/xcmiscproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/lib/libxtrans
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/bigreqsproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/xextproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/fontsproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/videoproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/recordproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/resourceproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/xf86driproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/proto/randrproto
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/lib/libxkbfile
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/lib/libXfont
RUN /tmp/clone_or_update.sh git://anongit.freedesktop.org/xorg/xserver

ADD scripts/gen.sh /tmp/gen.sh
ADD scripts/g_and_c.sh /tmp/g_and_c.sh
RUN mkdir -p $WLD/share/aclocal

RUN /tmp/g_and_c.sh wayland
RUN /tmp/g_and_c.sh wayland-protocols
RUN /tmp/g_and_c.sh drm --disable-libkms
RUN /tmp/g_and_c.sh proto
RUN /tmp/g_and_c.sh macros
RUN /tmp/g_and_c.sh libxcb
RUN /tmp/g_and_c.sh presentproto
RUN /tmp/g_and_c.sh dri3proto
RUN /tmp/g_and_c.sh libxshmfence
RUN /tmp/g_and_c.sh libxkbcommon \
  --with-xkb-config-root=/usr/share/X11/xkb \
  --disable-x11

ADD scripts/compile.sh /tmp/compile.sh

RUN llvm_drivers=swrast,nouveau,r300,r600 && \
  vga_pci=$(lspci | grep VGA | head -n1) && \
  vga_name=${vga_pci#*controller: } && \
  vga_manu=${vga_name%% *} && \
  if [ "${vga_manu}" = "NVIDIA" ]; then \
    llvm_drivers=swrast,nouveau; \
  fi && \
  cd $WLROOT/mesa && \
  git clean -xfd && \
  ./autogen.sh --prefix=$WLD \
    --enable-gles2 \
    --with-egl-platforms=x11,wayland,drm \
    --enable-gbm \
    --enable-shared-glapi \
    --disable-llvm-shared-libs \
    --disable-dri3 \
    --with-gallium-drivers=$llvm_drivers && \
  /tmp/compile.sh mesa

RUN /tmp/g_and_c.sh pixman
RUN /tmp/g_and_c.sh cairo --enable-xcb --enable-gl

RUN cd $WLROOT/libunwind && \
  autoreconf -i && \
  ./configure --prefix=$WLD && \
  /tmp/compile.sh libunwind

RUN /tmp/g_and_c.sh libevdev
RUN /tmp/g_and_c.sh wayland-protocols
RUN /tmp/g_and_c.sh libwacom
RUN /tmp/g_and_c.sh libinput

RUN /tmp/g_and_c.sh xproto
RUN /tmp/g_and_c.sh libepoxy
RUN /tmp/g_and_c.sh glproto
RUN /tmp/g_and_c.sh xcmiscproto
RUN /tmp/g_and_c.sh libxtrans
RUN /tmp/g_and_c.sh bigreqsproto
RUN /tmp/g_and_c.sh xextproto
RUN /tmp/g_and_c.sh fontsproto
RUN /tmp/g_and_c.sh videoproto
RUN /tmp/g_and_c.sh recordproto
RUN /tmp/g_and_c.sh resourceproto
RUN /tmp/g_and_c.sh xf86driproto
RUN /tmp/g_and_c.sh randrproto
RUN /tmp/g_and_c.sh libxkbfile
RUN /tmp/g_and_c.sh libXfont

RUN echo "xserver" && \
    cd $WLROOT/xserver && \
    ./autogen.sh --prefix=$WLD --disable-docs --disable-devel-docs \
    --enable-xwayland --disable-xorg --disable-xvfb --disable-xnest \
    --disable-xquartz --disable-xwin && \
    /tmp/compile.sh xserver

RUN mkdir -p $WLD/share/X11/xkb/rules && \
    if [ ! -e $WLD/share/X11/xkb/rules/evdev ]; then \
      ln -s /usr/share/X11/xkb/rules/evdev $WLD/share/X11/xkb/rules/; \
    fi && \
    if [ ! -e $WLD/bin/xkbcomp ]; then \
      ln -s /usr/bin/xkbcomp $WLD/bin/; \
    fi

RUN echo "weston" && \
    cd $WLROOT/weston && \
    git clean -xfd && \
    ./autogen.sh --prefix=$WLD \
      --with-cairo=image \
      --with-xserver-path=$WLD/bin/Xwayland \
      --enable-setuid-install=no \
      --enable-clients \
      --enable-headless-compositor \
      --enable-demo-clients-install && \
    /tmp/compile.sh weston

RUN if [ ! -e $HOME/.config/weston.ini ]; then \
      cp $WLROOT/weston/weston.ini $HOME/.config/; \
    fi

RUN useradd -m $USER && \
  echo "$USER:$USER" | chpasswd && \
  usermod --shell /bin/bash $USER && \
  usermod -aG sudo $USER && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER && \
  usermod  --uid 420 $USER && \
  groupmod --gid 1337 $USER

ADD scripts/.bashrc /home/$USER/.bashrc
ADD scripts/wl_uninstalled.sh $WLROOT/wl_uninstalled.sh
USER $USER
RUN sudo chown -R $USER /home/$USER
# RUN sudo apt install -y xinit
# RUN sudo apt install -y xterm
CMD cd $WLROOT && bash
