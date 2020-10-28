#!/bin/bash
set -euo pipefail

export WAYLAND_DISPLAY=wayland-mate # This will be the Wayland display Mirco creates
export XDG_RUNTIME_DIR=/run/user/$(id -u) # Since this is a classic snap, this should be set to the normal value
export QT_QPA_PLATFORM=wayland # Force Wayland for Qt apps
export GDK_BACKEND=wayland # GTK apps will generally default to Wayland, but some (like Firefox) need the extra hint

${SNAP}/bin/mirco.sh $@ &
SERVER_PID=$!

# Wait for the socket to appear
SOCKET_PATH="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
i=0
while test ! -S "$SOCKET_PATH"; do
    if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "ERROR: server failed to start"
        exit 1
    fi
    i=$((i + 1))
    if test $i -gt 50; then
        echo "ERROR: server did not create $WAYLAND_DISPLAY"
        kill -9 "$SERVER_PID"
        wait "$SERVER_PID"
        exit 1
    fi
    echo sleeping
    sleep 0.05
done

echo "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-[nil]}"
echo "XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-[nil]}"

COMPONENT_PIDS=""

$SNAP/bin/background.sh &
COMPONENT_PIDS="$COMPONENT_PIDS $!"

$SNAP/bin/panel.sh &
COMPONENT_PIDS="$COMPONENT_PIDS $!"

# Wait for all components and the server to exit
wait $COMPONENT_PIDS $SERVER_PID
