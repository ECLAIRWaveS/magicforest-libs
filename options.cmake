message(STATUS "${PROJECT_NAME} CMake ${CMAKE_VERSION}  ${CMAKE_SYSTEM_NAME} Toolchain ${CMAKE_TOOLCHAIN_FILE}")

# --- user options

option(BUILD_SHARED_LIBS "Build shared libraries")

if(local)
  get_filename_component(local ${local} ABSOLUTE)

  if(NOT IS_DIRECTORY ${local})
    message(FATAL_ERROR "Local directory ${local} does not exist")
  endif()
endif()

# --- other options

if(NOT DEFINED CRAY AND DEFINED ENV{CRAYPE_VERSION})
  set(CRAY true)
endif()

set(CMAKE_TLS_VERIFY true)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please define library install prefix like:
  cmake -DCMAKE_INSTALL_PREFIX=/path/to/install")
endif()
# --- exclude Conda from search - this avoids incompatible libraries being found
if(DEFINED ENV{CONDA_PREFIX})
  set(ignore_path
    $ENV{CONDA_PREFIX} $ENV{CONDA_PREFIX}/Library $ENV{CONDA_PREFIX}/Scripts $ENV{CONDA_PREFIX}/condabin
    $ENV{CONDA_PREFIX}/bin $ENV{CONDA_PREFIX}/lib $ENV{CONDA_PREFIX}/include
    $ENV{CONDA_PREFIX}/Library/bin $ENV{CONDA_PREFIX}/Library/lib $ENV{CONDA_PREFIX}/Library/include
  )
  list(APPEND CMAKE_IGNORE_PATH ${ignore_path})
endif()

# --- look in CMAKE_PREFIX_PATH for Find*.cmake as well
if(NOT DEFINED CMAKE_PREFIX_PATH AND DEFINED ENV{CMAKE_MODULE_PATH})
  set(CMAKE_PREFIX_PATH $ENV{CMAKE_MODULE_PATH})
endif()
if(CMAKE_PREFIX_PATH)
  get_filename_component(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ABSOLUTE)

  list(APPEND CMAKE_MODULE_PATH ${CMAKE_PREFIX_PATH}/cmake)
endif()

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_INSTALL_PREFIX})

# --- auto-ignore build directory
if(NOT PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  file(GENERATE OUTPUT .gitignore CONTENT "*")
endif()

# --- check for updated external projects when "false"
set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED false)
