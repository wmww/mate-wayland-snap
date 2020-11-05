#!/bin/bash
set -euo pipefail

export WAYLAND_DISPLAY=wayland-mate # This will be the Wayland display Mirco creates
export XDG_RUNTIME_DIR=/run/user/$(id -u) # Since this is a classic snap, this should be set to the normal value
export QT_QPA_PLATFORM=wayland # Force Wayland for Qt apps
export GDK_BACKEND=wayland,x11 # Ask GTK apps to prefer Wayland, but allow them to fall back to X11 if they must
export MOZ_ENABLE_WAYLAND=1 # Make Firefox use Wayland

# Once Mir starts up, it will drop the X11 display number into this file
XWAYLAND_DISPLAY_FILE=$(mktemp mir-x11-display.XXXXXX --tmpdir)

"$SNAP"/bin/mirco.sh $@ --x11-displayfd 5 5>"$XWAYLAND_DISPLAY_FILE" &
SERVER_PID=$!

echo "Waiting for DISPLAY to appear in $XWAYLAND_DISPLAY_FILE"
# The inotify solution doesn't seem to work
# "$SNAP"/usr/bin/inotifywait --event close_write "$XWAYLAND_DISPLAY_FILE"
while test -z $(cat "$XWAYLAND_DISPLAY_FILE"); do
  sleep 0.05
done
export DISPLAY=":$(cat "$XWAYLAND_DISPLAY_FILE")"
rm "$XWAYLAND_DISPLAY_FILE"
echo "DISPLAY=$DISPLAY, $XWAYLAND_DISPLAY_FILE deleted"

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
echo "DISPLAY: ${DISPLAY:-[nil]}"

COMPONENT_PIDS=""

$SNAP/bin/background.sh &
COMPONENT_PIDS="$COMPONENT_PIDS $!"

$SNAP/bin/panel.sh &
COMPONENT_PIDS="$COMPONENT_PIDS $!"

# Wait for all components and the server to exit
wait $COMPONENT_PIDS $SERVER_PID
