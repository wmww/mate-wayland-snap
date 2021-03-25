#!/bin/bash
set -euo pipefail

export MIR_CLIENT_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/client-platform
export MIR_SERVER_PLATFORM_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/mir/server-platform
export __EGL_VENDOR_LIBRARY_DIRS=${SNAP}/etc/glvnd/egl_vendor.d:${SNAP}/usr/share/glvnd/egl_vendor.d
export LIBGL_DRIVERS_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}/dri
export MIR_SERVER_ENABLE_X11=1
export LD_LIBRARY_PATH=${SNAP}/usr/lib/${SNAPCRAFT_ARCH_TRIPLET}:${SNAP}/lib/${SNAPCRAFT_ARCH_TRIPLET}
export XDG_RUNTIME_DIR=/run/user/${UID}

# Run server
exec ${SNAP}/usr/local/bin/mirco $@
