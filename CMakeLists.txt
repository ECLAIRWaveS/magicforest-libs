cmake_minimum_required(VERSION 3.20...3.24)

if(NOT CMAKE_BUILD_TYPE)
  # ignore ENV{CMAKE_BUILD_TYPE} as we want to directly capture this project's user intent
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

project(MagicForestLibs LANGUAGES C CXX Fortran)

include(cmake/options.cmake)
include(cmake/compilers.cmake)

# template function
include(cmake/ExtProj.cmake)

# --- main program

find_package(MPI COMPONENTS C CXX Fortran REQUIRED)

# --- Zlib
set(zlib_cmake_args
-DZLIB_COMPAT:BOOL=on
-DZLIB_ENABLE_TESTS:BOOL=off
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
)
# CMAKE_POSITION_INDEPENDENT_CODE=on is needed for Zlib even when using static libs.

extproj(zlib git "${zlib_cmake_args}" "")

# --- AMR libs

set(amr_args
-Dmpi:BOOL=true
)
if(MPI_ROOT)
  list(APPEND amr_args -DMPI_ROOT:PATH=${MPI_ROOT})
endif()

extproj(libsc git "${amr_args}" "zlib")
extproj(p4est git "${amr_args}" "libsc")
set(fclaw_args ${amr_args} -Dclawpatch:BOOL=true -Dclawpack:BOOL=true)
extproj(forestclaw git "${fclaw_args}" "p4est")
