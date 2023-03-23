include_guard()

if(CMAKE_VERSION VERSION_LESS 3.19)
  include(${CMAKE_CURRENT_LIST_DIR}/Modules/JsonParse.cmake)
endif()


function(get_url name json)

if(NOT json)
  message(FATAL_ERROR "get_url: ${name}: JSON string is empty")
endif()

if(CMAKE_VERSION VERSION_LESS 3.19)
  sbeParseJson(meta json)
  set(url ${meta.${name}.url})
else()
  string(JSON url GET ${json} ${name} url)
endif()

set(url ${url} PARENT_SCOPE)

endfunction(get_url)


function(get_tag name json)

if(CMAKE_VERSION VERSION_LESS 3.19)
  sbeParseJson(meta json)
  set(tag ${meta.${name}.tag})
else()
  string(JSON tag GET ${json} ${name} tag)
endif()

set(tag ${tag} PARENT_SCOPE)

endfunction(get_tag)


function(get_hash name json)

if(CMAKE_VERSION VERSION_LESS 3.19)
  sbeParseJson(meta json)
  set(sha256 ${meta.${name}.sha256})
else()
  string(JSON sha256 GET ${json} ${name} sha256)
endif()

set(sha256 ${sha256} PARENT_SCOPE)

endfunction(get_hash)
