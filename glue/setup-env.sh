#!/bin/bash

# For a classic snap this needs to be something sane
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Force Wayland for Qt apps
export QT_QPA_PLATFORM=wayland

# GTK apps will generally default to Wayland, but some (like Firefox) need the extra hint
export GDK_BACKEND=wayland
