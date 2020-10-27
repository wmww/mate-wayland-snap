#!/bin/bash
set -euo pipefail

if x11_display=$(snapctl get x11-display); then
  if [ -n "${x11_display}" ]; then
    if [ "${x11_display}" == "auto" ]; then
      x11_display=0

      while [ -e "/tmp/.X11-unix/X${x11_display}" ]; do
        let x11_display+=1
      done
    fi
    if [ ${x11_display} -eq ${x11_display} 2>/dev/null ]; then
      export MIR_SERVER_X11_DISPLAY_EXPERIMENTAL=${x11_display}
      export MIR_X11_LAZY=on
    fi
  fi
fi

export MIR_CLIENT_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/client-platform
export MIR_SERVER_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/server-platform
export __EGL_VENDOR_LIBRARY_DIRS=${SNAP}/etc/glvnd/egl_vendor.d:${SNAP}/usr/share/glvnd/egl_vendor.d

# Run server
exec dbus-run-session -- ${SNAP}/bin/mirco --enable-x11 $@