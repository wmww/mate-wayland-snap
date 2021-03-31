#!/bin/bash

# Enable XWayland and set up Mir to work
export MIR_SERVER_ENABLE_X11=1
export MIR_SERVER_XWAYLAND_PATH=${SNAP}/usr/bin/Xwayland
export MIR_CLIENT_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/client-platform
export MIR_SERVER_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/server-platform

# Point the GL drivers to the right places
export __EGL_VENDOR_LIBRARY_DIRS=${SNAP}/etc/glvnd/egl_vendor.d:${SNAP}/usr/share/glvnd/egl_vendor.d
export LIBGL_DRIVERS_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/dri

# Set XDG_RUNTIME_DIR to the normal value it would be outside of the snap
export XDG_RUNTIME_DIR=/run/user/${UID}

# LD_LIBRARY_PATH is not set. If we set it to only include directories inside the snap, XWayland doesn't start
# I believe this is beause XWayland is launching binaries (sh?) from outside the snap that would then get the wrong libc

# Run server
exec ${SNAP}/usr/local/bin/mirco $@
