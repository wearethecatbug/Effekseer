cmake_minimum_required(VERSION 3.15)
project(EffekseerRendererWebGPU)

# Include FilterFolder function (already included by parent CMakeLists.txt)
# include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/FilterFolder.cmake)

# WebGPU support
option(WEBGPU_EMSCRIPTEN "Build for Emscripten (browser)" OFF)
option(WEBGPU_DAWN "Build with Dawn (native)" ON)

file(GLOB_RECURSE LOCAL_HEADERS_WebGPU *.h)
file(GLOB_RECURSE LOCAL_SOURCES_WebGPU *.cpp)

FilterFolder("${LOCAL_HEADERS_WebGPU}")
FilterFolder("${LOCAL_SOURCES_WebGPU}")

set(LOCAL_SOURCES
    ${LOCAL_HEADERS_WebGPU}
    ${LOCAL_SOURCES_WebGPU})

set(PublicHeaders
    EffekseerRendererWebGPU.h
    EffekseerRendererWebGPU/EffekseerRendererWebGPU.Base.Pre.h
    EffekseerRendererWebGPU/EffekseerRendererWebGPU.Renderer.h)

#--------------------
# Projects

add_library(${PROJECT_NAME} STATIC ${LOCAL_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/../3rdparty/LLGI/src 
    ${EFK_THIRDPARTY_INCLUDES})

# WebGPU includes
if(WEBGPU_EMSCRIPTEN OR EMSCRIPTEN)
    # Emscripten provides WebGPU headers
    target_compile_definitions(${PROJECT_NAME} PRIVATE __EMSCRIPTEN__)
elseif(WEBGPU_DAWN)
    if(DEFINED DAWN_INCLUDE_DIR)
        target_include_directories(${PROJECT_NAME} PRIVATE ${DAWN_INCLUDE_DIR})
    else()
        # Use stub headers for compilation testing
        message(STATUS "DAWN_INCLUDE_DIR not set for EffekseerRendererWebGPU, using stub headers")
        target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/../3rdParty/LLGI/src/WebGPU/stub_headers)
    endif()
    target_compile_definitions(${PROJECT_NAME} PRIVATE LLGI_WEBGPU_DAWN)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "${PublicHeaders}")
target_link_libraries(${PROJECT_NAME} PUBLIC Effekseer EffekseerRendererCommon EffekseerRendererLLGI LLGI)

target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>)

if(CLANG_FORMAT_ENABLED)
    clang_format(${PROJECT_NAME})
endif()

#--------------------
# Install

foreach(file ${PublicHeaders})
    get_filename_component(dir ${file} DIRECTORY)
    install(FILES ${file} DESTINATION include/${dir})
endforeach()

install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-export
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib)

install(
    EXPORT ${PROJECT_NAME}-export
    FILE ${PROJECT_NAME}-config.cmake
    DESTINATION lib/cmake
    EXPORT_LINK_INTERFACE_LIBRARIES)
