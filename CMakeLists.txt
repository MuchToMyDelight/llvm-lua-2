#
# llvm-lua
#
cmake_minimum_required(VERSION 2.8)

project(llvm_lua)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(CustomMacros)
include(CMakeDependentOption)
#
# llvm-lua options.
#
option(LUA_CPP_SUPPORT "Enable c++ support" OFF)
set(LLVM_PATH "/mnt/disk/llvm_snapshot/" CACHE STRING "Path to LLVM/Clang.")
set(LLVM_CC "${LLVM_PATH}/bin/clang" CACHE STRING "Command to compile C-code to LLVM bitcode (clang or llvm-gcc)")
set(LLVM_LD "${LLVM_PATH}/bin/llvm-link" CACHE STRING "Command to link LLVM bitcode files into one bitcode file.")
include(FindLLVM)


set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES ${LLVM_LIBDIR})

enable_testing()

set(LLVM_LUA_NAME "llvm-lua")
set(LLVM_LUA_COPYRIGHT
"Copyright (C) 2008-2009 Robert G. Jakabosky, http://code.google.com/p/llvm-lua/")

#
# Lua version
#
set(LUA_VERSION_MAJOR 5)
set(LUA_VERSION_MINOR 1)
set(LUA_VERSION_PATCH 4)
set(LUA_VERSION
    "${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}.${LUA_VERSION_PATCH}")
set(LUA_SOVERSION
    "${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}")

#
# llvm-lua version
#
set(LLVM_LUA_VERSION_MAJOR 2)
set(LLVM_LUA_VERSION_MINOR 0)
set(LLVM_LUA_VERSION_PATCH 0)
set(LLVM_LUA_VERSION
    "${LLVM_LUA_VERSION_MAJOR}.${LLVM_LUA_VERSION_MINOR}.${LLVM_LUA_VERSION_PATCH}")
set(LLVM_LUA_SOVERSION
    "${LLVM_LUA_VERSION_MAJOR}.${LLVM_LUA_VERSION_MINOR}")

#
# Lua package info.
#
set(CPACK_PACKAGE_VERSION_MAJOR ${LLVM_LUA_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${LLVM_LUA_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${LLVM_LUA_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYRIGHT")
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README")
set(CPACK_PACKAGE_VENDOR "")
set(CPACK_SOURCE_GENERATOR "TGZ")
set(CPACK_SOURCE_IGNORE_FILES
"/\\\\.;/\\\\.git.*/;~$;build/;CMakeFiles/;CMakeCache;Testing/;cmake_install;CPack;Dart;Makefile$")
set(CPACK_SOURCE_PACKAGE_FILE_NAME
    "${LLVM_LUA_NAME}-${LLVM_LUA_VERSION_MAJOR}.${LLVM_LUA_VERSION_MINOR}.${LLVM_LUA_VERSION_PATCH}")
# MUST be after CPACK_* variables.
include(CPack)

set(COMMON_CFLAGS)
set(COMMON_LDFLAGS)
set(LIBS)
#
# Detect system type
#

set(DEFAULT_POSIX TRUE)
set(DEFAULT_DLOPEN ON)
set(DEFAULT_READLINE ON)
set(COMMON_LDFLAGS "${COMMON_LDFLAGS} -Wl,-E")
set(USE_RPATH TRUE)
# This is a HACK.  We need to put the flags from `llvm-config --lflags` at
# the end of the linker command.  If you know a better way to fix this let
# me know.
set(CMAKE_CXX_LINK_EXECUTABLE
        "<CMAKE_CXX_COMPILER>  <FLAGS> <CMAKE_CXX_LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> <LINK_FLAGS>")
SET(CMAKE_C_LINK_EXECUTABLE
        "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> <LINK_FLAGS>")


#
# setup config options with default values.
#
option(WANT_SHARED_LIBRARY "Set to ON to build dynamic library." ON)
option(WANT_STATIC_LIBRARY "Set to ON to build static library." ON)
option(WANT_NOJIT_LIBRARIES "Set to ON to build nojit libraries." ON)

if(USE_RPATH)
        set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib" CACHE STRING "rpaths separated by semicolons.")
        option(CMAKE_BUILD_WITH_INSTALL_RPATH "Set to YES to set the rpath or install_name on build instead of install." OFF)
endif()

if(DEFAULT_DLOPEN)
        option(LUA_USE_DLOPEN "Enable dlopen support." ON)
else()
        option(LUA_USE_DLOPEN "Enable dlopen support." OFF)
endif()

if(DEFAULT_POSIX)
        option(LUA_USE_CURSES "Enable Curses support." ON)
        option(LUA_USE_MKSTEMP "Use mkstemp." ON)
        option(LUA_USE_ISATTY "Enable isatty support." ON)
        option(LUA_USE_POPEN "Enable lua_popen support." ON)
        option(LUA_USE_ULONGJMP "Try using _longjmp/_setjmp (more efficient)" ON)
else()
        option(LUA_USE_CURSES "Enable Curses support." OFF)
        option(LUA_USE_MKSTEMP "Use mkstemp." OFF)
        option(LUA_USE_ISATTY "Enable isatty support." OFF)
        option(LUA_USE_POPEN "Enable lua_popen support." OFF)
        option(LUA_USE_ULONGJMP "Try using _longjmp/_setjmp (more efficient)" OFF)
endif()

if(DEFAULT_READLINE)
        option(LUA_USE_READLINE "Enable readline support." ON)
else()
        option(LUA_USE_READLINE "Enable readline support." OFF)
endif()

if(DEFAULT_ANSI)
        option(LUA_ANSI "Disable non-ansi features." ON)
else()
        option(LUA_ANSI "Disable non-ansi features." OFF)
endif()

option(LUA_USE_APICHECK "Enable API checks." OFF)

#
# Cross-compile options.
#
option(CROSS_COMPILE "Build llvm-luac as a cross-compiler" OFF)
set(CROSS_ARCH "arm" CACHE STRING "Cross-compiler target.")
set(CROSS_TRIPLE "arm-linux-gnueabi" CACHE STRING "Cross-compiler target triple.")
set(CROSS_CPU "arm926ej-s" CACHE STRING "Cross-compiler target cpu name.")
set(CROSS_ISYSTEM
        "/usr/lib/gcc/arm-linux-gnueabi/4.6.3/include:/usr/lib/gcc/arm-linux-gnueabi/4.6.3/include-fixed:/usr/arm-linux-gnueabi/usr/include/"
        CACHE STRING "Path to target system includes.")

#
# LuaCoco options
#
option(COCO_USE_SETJMP "Coco: Force use of setjmp (instead of gccasm)" OFF)
option(COCO_USE_UCONTEXT "Coco: Force use of ucontext (instead of gccasm or setjmp)" OFF)
option(COCO_USE_VALGRIND "Enable valgrind debugging support" OFF)
option(COCO_DISABLE "Disable coco" OFF)
set(COCO_DEFAULT_CSTACKSIZE "" CACHE STRING "Coco default cstacksize")

#
# libs & cflags
#
set(COMMON_LDFLAGS "${COMMON_LDFLAGS} -lm ")

# enable options
if(LUA_USE_DLOPEN)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_DLOPEN")
        if(NOT APPLE)
                set(COMMON_LDFLAGS "${COMMON_LDFLAGS} -ldl ")
        endif()
endif()
if(LUA_USE_MKSTEMP)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_MKSTEMP")
endif()
if(LUA_USE_ISATTY)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_ISATTY")
endif()
if(LUA_USE_POPEN)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_POPEN")
endif()
if(LUA_USE_ULONGJMP)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_ULONGJMP")
endif()
if(LUA_USE_APICHECK)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_APICHECK")
endif()
if(LUA_ANSI)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_ANSI")
endif()

# readline support
if(LUA_USE_READLINE AND NOT CROSS_COMPILE)
        FIND_PATH(READLINE_INCLUDE_DIR readline/readline.h)
        FIND_LIBRARY(READLINE_LIBRARY NAMES readline)
        if(READLINE_LIBRARY)
                set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_READLINE")
                set(COMMON_LDFLAGS "${COMMON_LDFLAGS} -lreadline -lhistory")
                include_directories(${READLINE_INCLUDE_DIR})
        endif()
endif()

# curses
if(LUA_USE_CURSES AND NOT CROSS_COMPILE)
        include(FindCurses)
        if(CURSES_LIBRARY)
                include_directories(${CURSES_INCLUDE_DIR})
                set(LIBS ${LIBS} ${CURSES_LIBRARY})
        endif()
endif()

# LuaCoco flags
if(COCO_DISABLE)
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DCOCO_DISABLE")
else()
        if(COCO_USE_SETJMP)
                set(COMMON_CFLAGS "${COMMON_CFLAGS} -DCOCO_USE_SETJMP")
        elseif(COCO_USE_UCONTEXT)
                set(COMMON_CFLAGS "${COMMON_CFLAGS} -DCOCO_USE_UCONTEXT")
        endif()

        # check cstacksize variable.
        if(COCO_DEFAULT_CSTACKSIZE)
                set(COMMON_CFLAGS "${COMMON_CFLAGS} -DCOCO_DEFAULT_CSTACKSIZE=${COCO_DEFAULT_CSTACKSIZE}")
        endif()
endif()

#
# Support for embedding llvm-lua into c++ programs with exception support.
#
if(LUA_CPP_SUPPORT)
        message(STATUS "Lua C++ support enabled, forcing usage of g++ & llvm-g++")
        set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_CPP_SUPPORT")
        include(CMakeForceCompiler)
        CMAKE_FORCE_C_COMPILER(${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ID})
        set(LLVM_CC "llvm-g++")
endif()

#
# standard flags to use for each build type.
#
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -Wall -Wshadow -W -std=gnu89 ")
set(CMAKE_C_FLAGS_RELEASE        "${CMAKE_C_FLAGS_RELEASE}     -O2")
set(CMAKE_C_FLAGS_DEBUG          "${CMAKE_C_FLAGS_DEBUG}       -O0 -g")
set(CMAKE_C_FLAGS_PROFILE        "${CMAKE_C_FLAGS_PROFILE}     -O1 -g")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_WITHDEBINFO} -O2 -g")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -std=c++11 -pipe -Wall -Wshadow -W -pedantic")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS_RELEASE}     -O2")
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS_DEBUG}       -O0 -g")
set(CMAKE_CXX_FLAGS_PROFILE        "${CMAKE_CXX_FLAGS_PROFILE}     -O2 -g")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_WITHDEBINFO} -O2 -g")

#
# For uninstall (needs cmake_uninstall.cmake.in in the top-level directory)
#
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
  @ONLY)
add_custom_target(uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")

#
# sub-folders
#
add_subdirectory(llvm-lua build)
