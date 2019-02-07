#!/bin/bash

# For a classic snap this needs to be something sane
export XDG_RUNTIME_DIR=/run/user/$(id -u)
