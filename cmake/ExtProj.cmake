include(ExternalProject)

function(extproj name url_type cmake_args depends)

# PREPEND so that user arguments can override these defaults
list(PREPEND cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
-DBUILD_TESTING:BOOL=false
-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
)

string(JSON url GET ${json_meta} ${name} url)

if(url_type STREQUAL "git")

  string(JSON tag GET ${json_meta} ${name} tag)

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

  string(JSON sha256 GET ${json_meta} ${name} sha256)

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
