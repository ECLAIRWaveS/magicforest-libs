include(ExternalProject)

if(CMAKE_VERSION VERSION_LESS 3.19)
  include(${CMAKE_CURRENT_LIST_DIR}/Modules/JsonParse.cmake)
endif()

function(extproj name url_type cmake_args depends)

# PREPEND so that user arguments can override these defaults
list(INSERT cmake_args 0
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
-DBUILD_TESTING:BOOL=false
)
if(CMAKE_TOOLCHAIN_FILE)
  list(APPEND cmake_args -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${CMAKE_TOOLCHAIN_FILE})
endif()

if(CMAKE_VERSION VERSION_LESS 3.19)
  sbeParseJson(meta json_meta)
  set(url ${meta.${name}.url})
else()
  string(JSON url GET ${json_meta} ${name} url)
endif()

if(url_type STREQUAL "git")

  if(CMAKE_VERSION VERSION_LESS 3.19)
    set(tag ${meta.${name}.tag})
  else()
    string(JSON tag GET ${json_meta} ${name} tag)
  endif()

  ExternalProject_Add(${name}
  GIT_REPOSITORY ${url}
  GIT_TAG ${tag}
  GIT_SHALLOW true
  CMAKE_ARGS ${cmake_args}
  INACTIVITY_TIMEOUT 60
  CONFIGURE_HANDLED_BY_BUILD true
  TEST_COMMAND ""
  DEPENDS ${depends}
  )
elseif(url_type STREQUAL "archive")

  if(CMAKE_VERSION VERSION_LESS 3.19)
    set(sha256 ${meta.${name}.sha256})
  else()
    string(JSON sha256 GET ${json_meta} ${name} sha256)
  endif()

  ExternalProject_Add(${name}
  URL ${url}
  URL_HASH SHA256=${sha256}
  CMAKE_ARGS ${cmake_args}
  INACTIVITY_TIMEOUT 60
  CONFIGURE_HANDLED_BY_BUILD true
  TEST_COMMAND ""
  DEPENDS ${depends}
  )
else()
  message(FATAL_ERROR "unsure how to use resource of type ${url_type")
endif()

endfunction(extproj)
