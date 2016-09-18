__Launch the Weston Compositor in Docker!__

```
docker pull dhoodlum/debian-wayland
docker run -ti --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  dhoodlum/debian-wayland
```


When you are inside the container, launch weston!

```
weston
```


If you are on an OSX computer, you need XQuartz to view the X11 window. You should whitelist the connections using `xhost $ip` on both ends.
