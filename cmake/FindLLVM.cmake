# - Find libev
# Find the native LLVM includes and library
#
#  LLVM_INCLUDE_DIR - where to find ev.h, etc.
#  LLVM_LIBRARIES   - List of libraries when using libev.
#  LLVM_FOUND       - True if libev found.

set(LLVM_CONFIG_EXECUTABLE "${LLVM_PATH}/bin/llvm-config")

if(EXISTS ${LLVM_CONFIG_EXECUTABLE})
    message(STATUS "Use ${LLVM_CONFIG_EXECUTABLE}")
else()
    message(FATAL_ERROR "can't find ${LLVM_CONFIG_EXECUTABLE}")
endif()
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --cppflags
        OUTPUT_VARIABLE LLVM_CFLAGS
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --ldflags
        OUTPUT_VARIABLE LLVM_LFLAGS
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --includedir
        OUTPUT_VARIABLE LLVM_INCLUDE_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --libdir
        OUTPUT_VARIABLE LLVM_LIB_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --libs core jit native linker bitreader bitwriter ipo
        OUTPUT_VARIABLE LLVM_JIT_LIBS
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --libs all
        OUTPUT_VARIABLE LLVM_ALL_LIBS
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
execute_process(
        COMMAND ${LLVM_CONFIG_EXECUTABLE} --libs Support
        OUTPUT_VARIABLE LLVM_SUPPORT_LIB
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
