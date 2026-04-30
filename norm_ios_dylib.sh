#!/usr/bin/env bash
set -e

otool -L lib/ios-arm64/libEGL.framework/libEGL
otool -L lib/ios-arm64/libGLESv2.framework/libGLESv2
