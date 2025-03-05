cmake_minimum_required(VERSION 3.15)
project(angle)

set(CMAKE_CXX_STANDARD 17)

include(GNUInstallDirs)

option(ANGLE_BUILD_INSTALL "Build install" OFF)
option(ANGLE_EXCLUDE_REGISTRY_HEADERS "Exclude registry headers" OFF)

set(ANGLE_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include")

if (APPLE)
    if (CMAKE_OSX_ARCHITECTURES MATCHES "arm64")
        set(ANGLE_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/lib/macos-arm64")
    elseif (CMAKE_OSX_ARCHITECTURES MATCHES "x86_64")
        set(ANGLE_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/lib/macos-x64")
    else ()
        message(FATAL_ERROR "Unsupported macos architecture: ${CMAKE_OSX_ARCHITECTURES}")
    endif ()
elseif (WIN32)
    set(ANGLE_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/lib/windows-x64")
else ()
    message(FATAL_ERROR "Unsupported platform")
endif ()

add_library(libEGL INTERFACE)
target_include_directories(libEGL INTERFACE
        "$<BUILD_INTERFACE:${ANGLE_INCLUDE_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_link_directories(libEGL INTERFACE
        "$<BUILD_INTERFACE:${ANGLE_LIB_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}>"
)
if (WIN32)
    target_link_libraries(libEGL INTERFACE "libEGL.lib")
else()
    target_link_libraries(libEGL INTERFACE "EGL")
endif ()
add_library(unofficial::angle::libEGL ALIAS libEGL)

add_library(libGLESv2 INTERFACE)
target_include_directories(libGLESv2 INTERFACE
        "$<BUILD_INTERFACE:${ANGLE_INCLUDE_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_link_directories(libGLESv2 INTERFACE
        "$<BUILD_INTERFACE:${ANGLE_LIB_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}>"
)
if (WIN32)
    target_link_libraries(libGLESv2 INTERFACE "libGLESv2.lib")
else()
    target_link_libraries(libGLESv2 INTERFACE "GLESv2")
endif ()
add_library(unofficial::angle::libGLESv2 ALIAS libGLESv2)

if (ANGLE_BUILD_INSTALL)
    include(CMakePackageConfigHelpers)
    install(TARGETS libEGL libGLESv2 EXPORT unofficial-angle)
    install(
            EXPORT unofficial-angle
            FILE unofficial-angle-targets.cmake
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-angle"
            NAMESPACE unofficial::angle::
    )
    configure_package_config_file(
            "${CMAKE_CURRENT_LIST_DIR}/unofficial-angle-config.cmake.in"
            "${CMAKE_CURRENT_BINARY_DIR}/unofficial-angle-config.cmake"
            INSTALL_DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-angle"
    )
    install(
            FILES "${CMAKE_CURRENT_BINARY_DIR}/unofficial-angle-config.cmake"
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-angle"
    )

    if (ANGLE_EXCLUDE_REGISTRY_HEADERS)
        install(
                DIRECTORY "${ANGLE_INCLUDE_DIR}/"
                DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
                FILES_MATCHING
                    PATTERN "*.h"
                    PATTERN "KHR" EXCLUDE
                    PATTERN "EGL/egl.h" EXCLUDE
                    PATTERN "EGL/eglext.h" EXCLUDE
                    PATTERN "EGL/eglplatform.h" EXCLUDE
                    PATTERN "GLES/egl.h" EXCLUDE
                    PATTERN "GLES/gl.h" EXCLUDE
                    PATTERN "GLES/glext.h" EXCLUDE
                    PATTERN "GLES/glplatform.h" EXCLUDE
                    PATTERN "GLES2/gl2.h" EXCLUDE
                    PATTERN "GLES2/gl2ext.h" EXCLUDE
                    PATTERN "GLES2/gl2platform.h" EXCLUDE
                    PATTERN "GLES3/gl3.h" EXCLUDE
                    PATTERN "GLES3/gl31.h" EXCLUDE
                    PATTERN "GLES3/gl32.h" EXCLUDE
                    PATTERN "GLES3/gl3platform.h" EXCLUDE
        )
    else ()
        install(
                DIRECTORY "${ANGLE_INCLUDE_DIR}/"
                DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        )
    endif()

    
    if (WIN32)
        file(GLOB ANGLE_LIBS "${ANGLE_LIB_DIR}/*.lib")
        file(GLOB ANGLE_DLLS "${ANGLE_LIB_DIR}/*.dll")
        install(
                FILES ${ANGLE_LIBS}
                DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        )
        install(
                FILES ${ANGLE_DLLS}
                DESTINATION "${CMAKE_INSTALL_BINDIR}"
        )
    else ()
        install(
                DIRECTORY "${ANGLE_LIB_DIR}/"
                DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        )
    endif ()
endif ()
