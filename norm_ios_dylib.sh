#!/usr/bin/env bash
set -e

install_name_tool -id "@rpath/libEGL.dylib" lib/ios-arm64/libEGL.dylib
install_name_tool -id "@rpath/libGLESv2.dylib" lib/ios-arm64/libGLESv2.dylib

codesign -f -s - lib/ios-arm64/libEGL.dylib
codesign -f -s - lib/ios-arm64/libGLESv2.dylib

otool -L lib/ios-arm64/libEGL.dylib
otool -L lib/ios-arm64/libGLESv2.dylib
