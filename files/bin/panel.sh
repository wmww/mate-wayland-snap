#!/bin/bash
set -euo pipefail

export MATE_PANEL_APPLETS_DIR=$SNAP/usr/share/mate-panel/applets/
export MATE_PANEL_APPLET_LIB_PREFIX=$SNAP/
export MATE_PANEL_DATA_DIR=$SNAP/usr/share/mate-panel/
exec $SNAP/usr/bin/mate-panel $@
