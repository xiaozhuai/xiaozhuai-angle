#!/usr/bin/env bash
set -e

lipo lib/macos-universal/libEGL.dylib -thin arm64 -output lib/macos-arm64/libEGL.dylib
lipo lib/macos-universal/libGLESv2.dylib -thin arm64 -output lib/macos-arm64/libGLESv2.dylib
lipo lib/macos-universal/libEGL.dylib -thin x86_64 -output lib/macos-x64/libEGL.dylib
lipo lib/macos-universal/libGLESv2.dylib -thin x86_64 -output lib/macos-x64/libGLESv2.dylib

install_name_tool -id "@rpath/libEGL.dylib" lib/macos-arm64/libEGL.dylib
install_name_tool -id "@rpath/libGLESv2.dylib" lib/macos-arm64/libGLESv2.dylib
install_name_tool -id "@rpath/libEGL.dylib" lib/macos-x64/libEGL.dylib
install_name_tool -id "@rpath/libGLESv2.dylib" lib/macos-x64/libGLESv2.dylib

codesign -f -s - lib/macos-arm64/libEGL.dylib
codesign -f -s - lib/macos-arm64/libGLESv2.dylib
codesign -f -s - lib/macos-x64/libEGL.dylib
codesign -f -s - lib/macos-x64/libGLESv2.dylib

otool -L lib/macos-arm64/libEGL.dylib
otool -L lib/macos-arm64/libGLESv2.dylib
otool -L lib/macos-x64/libEGL.dylib
otool -L lib/macos-x64/libGLESv2.dylib
