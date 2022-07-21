# --- user options

option(BUILD_SHARED_LIBS "Build shared libraries")

if(NOT DEFINED CRAY AND DEFINED ENV{CRAYPE_VERSION})
  set(CRAY true)
endif()

set(CMAKE_TLS_VERIFY true)

# --- config checks

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(is_multi_config OR CMAKE_GENERATOR MATCHES "Visual Studio")
  if(CMAKE_GENERATOR MATCHES "Ninja")
    set(suggest Ninja)
  elseif(WIN32)
    set(suggest "MinGW Makefiles")
  else()
    set(suggest "Unix Makefiles")
  endif()
  message(FATAL_ERROR "Please use a single configuration generator like:
  cmake -G \"${suggest}\"
  ")
endif()

# --- user must specify where to install libraries

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "Please define an install location like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/lib_magic")
endif()

# --- exclude Conda from search
if(DEFINED ENV{CONDA_PREFIX})
  set(ignore_path
    $ENV{CONDA_PREFIX} $ENV{CONDA_PREFIX}/Library $ENV{CONDA_PREFIX}/Scripts $ENV{CONDA_PREFIX}/condabin
    $ENV{CONDA_PREFIX}/bin $ENV{CONDA_PREFIX}/lib $ENV{CONDA_PREFIX}/include
    $ENV{CONDA_PREFIX}/Library/bin $ENV{CONDA_PREFIX}/Library/lib $ENV{CONDA_PREFIX}/Library/include
  )
  list(APPEND CMAKE_IGNORE_PATH ${ignore_path})
endif()

# --- CMake Module search path (for Find*.cmake)
cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules)

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
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# --- check for updated external projects when "false"
set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED false)

# --- read JSON with URLs for each library
file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json_meta)
