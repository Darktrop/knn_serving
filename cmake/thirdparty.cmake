add_custom_target(toolchain)

set(THIRDPARTY_DIR "${knn_SOURCE_DIR}/third_party")
if (NOT KNN_VERBOSE_THIRDPARTY_BUILD)
    set(EP_LOG_OPTIONS LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1 LOG_DOWNLOAD 1)
else()
    set(EP_LOG_OPTIONS)
endif()

set(EP_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_${UPPERCASE_BUILD_TYPE}}")
set(EP_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${UPPERCASE_BUILD_TYPE}}")

set(EP_C_FLAGS "${EP_C_FLAGS} -fPIC")
set(EP_CXX_FLAGS "${EP_CXX_FLAGS} -fPIC")

file(STRINGS "${THIRDPARTY_DIR}/versions.txt" TOOLCHAIN_VERSIONS_TXT)
foreach(_VERSION_ENTRY ${TOOLCHAIN_VERSIONS_TXT})
    if(NOT
    ((_VERSION_ENTRY MATCHES "^[^#][A-Za-z0-9-_]+_VERSION=")
            OR (_VERSION_ENTRY MATCHES "^[^#][A-Za-z0-9-_]+_CHECKSUM=")))
        continue()
    endif()
    string(REGEX MATCH "^[^=]*" _LIB_NAME ${_VERSION_ENTRY})
    string(REPLACE "${_LIB_NAME}=" "" _LIB_VERSION ${_VERSION_ENTRY})

    if(${_LIB_VERSION} STREQUAL "")
        continue()
    endif()
    message(STATUS "${_LIB_NAME}: ${_LIB_VERSION}")
    set(${_LIB_NAME} "${_LIB_VERSION}")
endforeach()

include(urls)
include(protobuf)
include(cares)
include(gflags)
include(grpc)
include(rapidjson)
include(zlib)
include(boost)

build_protobuf()
resolve_proto()
build_cares()
build_gflags()
build_rapidjson()
build_zlib()
build_grpc()
build_boost()

message(STATUS "Found protobuf headers: ${PROTOBUF_INCLUDE_DIR}")

get_target_property(PROTOBUF_INCLUDE_DIR protobuf::libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
include_directories(SYSTEM ${PROTOBUF_INCLUDE_DIR})
message(STATUS "Found protobuf headers: ${PROTOBUF_INCLUDE_DIR}")
get_target_property(CARES_INCLUDE_DIR c-ares::cares INTERFACE_INCLUDE_DIRECTORIES)
include_directories(SYSTEM ${CARES_INCLUDE_DIR})
get_target_property(GFLAGS_INCLUDE_DIR gflags INTERFACE_INCLUDE_DIRECTORIES)
include_directories(SYSTEM ${GFLAGS_INCLUDE_DIR})
get_target_property(RAPIDJSON_INCLUDE_DIR rapidjson INTERFACE_INCLUDE_DIRECTORIES)
include_directories(SYSTEM ${RAPIDJSON_INCLUDE_DIR})


