# Copyright (c) 2015 Alexandre Pretyman
# All rights reserved.
#
# ------------------------------------------------------------------------------
#  GCC Based Cross Compiler CMake toolchain file
#
#  Variables:
#   CROSS_COMPILE_TOOLCHAIN_PATH=/path/to/toolchain/bin
#   CROSS_COMPILE_TOOLCHAIN_PREFIX=arm-unknown-linux-gnueabihf
#   CROSS_COMPILE_SYSROOT=/path/to/sysroot [optional]
# ------------------------------------------------------------------------------

if(DEFINED POLLY_COMPILER_GCC_CROSS_COMPILE)
  return()
else()
  set(POLLY_COMPILER_GCC_CROSS_COMPILE TRUE)
endif()

if( CMAKE_TOOLCHAIN_FILE )
  # touch toolchain variable to suppress "unused variable" warning
endif()

string(COMPARE EQUAL
    "${CROSS_COMPILE_TOOLCHAIN_PATH}" 
    "" 
    _is_empty_cross_compile_toolchain_path
)
if(_is_empty_cross_compile_toolchain_path)
  poly_fatal_error("CROSS_COMPILE_TOOLCHAIN_PATH not set. Set it to the absolute path of the \"bin\" directory for the toolchain")
endif()

string(COMPARE EQUAL
    "${CROSS_COMPILE_TOOLCHAIN_PREFIX}" 
    "" 
    _is_empty_cross_compile_toolchain_prefix
)
if(_is_empty_cross_compile_toolchain_prefix)
  poly_fatal_error("CROSS_COMPILE_TOOLCHAIN_PREFIX not set. Set it to the triplet of the toolchain")
endif()


#Check for if sysroot exists, optional, since it could be hardcoded in the compiler
string(COMPARE NOTEQUAL "${CROSS_COMPILE_SYSROOT}" "" _has_sysroot)
if (_has_sysroot)
  set(SYSROOT_COMPILE_FLAG "--sysroot=${CROSS_COMPILE_SYSROOT}")
  polly_add_cache_flag(
      CMAKE_C_FLAGS   
      "${CMAKE_C_FLAGS} ${SYSROOT_COMPILE_FLAG}"
  )
  polly_add_cache_flag(
      CMAKE_CXX_FLAGS 
      "${CMAKE_CXX_FLAGS} ${SYSROOT_COMPILE_FLAG}"
  )
endif()

# The (...)_PREFIX variable name refers to the Cross Compiler Triplet
set(TOOLCHAIN_PATH_AND_PREFIX ${CROSS_COMPILE_TOOLCHAIN_PATH}/${CROSS_COMPILE_TOOLCHAIN_PREFIX})
set(CMAKE_C_COMPILER     "${TOOLCHAIN_PATH_AND_PREFIX}-gcc"     CACHE PATH "C compiler" )
set(CMAKE_CXX_COMPILER   "${TOOLCHAIN_PATH_AND_PREFIX}-g++"     CACHE PATH "C++ compiler" )
set(CMAKE_ASM_COMPILER   "${TOOLCHAIN_PATH_AND_PREFIX}-as"      CACHE PATH "Assembler" )
set(CMAKE_C_PREPROCESSOR "${TOOLCHAIN_PATH_AND_PREFIX}-cpp"     CACHE PATH "Preprocessor" )
set(CMAKE_STRIP          "${TOOLCHAIN_PATH_AND_PREFIX}-strip"   CACHE PATH "strip" )
if( EXISTS "${TOOLCHAIN_PATH_AND_PREFIX}-gcc-ar" )
  # Prefer gcc-ar over binutils ar: https://gcc.gnu.org/wiki/LinkTimeOptimizationFAQ
  set(CMAKE_AR           "${TOOLCHAIN_PATH_AND_PREFIX}-gcc-ar"  CACHE PATH "Archiver" )
else()
  set(CMAKE_AR           "${TOOLCHAIN_PATH_AND_PREFIX}-ar"      CACHE PATH "Archiver" )
endif()
set(CMAKE_LINKER         "${TOOLCHAIN_PATH_AND_PREFIX}-ld"      CACHE PATH "Linker" )
set(CMAKE_NM             "${TOOLCHAIN_PATH_AND_PREFIX}-nm"      CACHE PATH "nm" )
set(CMAKE_OBJCOPY        "${TOOLCHAIN_PATH_AND_PREFIX}-objcopy" CACHE PATH "objcopy" )
set(CMAKE_OBJDUMP        "${TOOLCHAIN_PATH_AND_PREFIX}-objdump" CACHE PATH "objdump" )
set(CMAKE_RANLIB         "${TOOLCHAIN_PATH_AND_PREFIX}-ranlib"  CACHE PATH "ranlib" )
