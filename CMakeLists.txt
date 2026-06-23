cmake_minimum_required(VERSION 3.20)
project(ModelConverter VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

# GLM - header-only OpenGL math
FetchContent_Declare(
    glm
    GIT_REPOSITORY https://github.com/g-truc/glm.git
    GIT_TAG 1.0.3
)

# xxhash_cpp - C++ wrapper for xxhash (header-only)
FetchContent_Declare(
    xxhash_cpp
    GIT_REPOSITORY https://github.com/RedSpah/xxhash_cpp.git
    GIT_TAG 0.8.1
)

# Assimp - Open Asset Import Library
set(ASSIMP_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_ASSIMP_TOOLS OFF CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_SAMPLES OFF CACHE BOOL "" FORCE)
set(ASSIMP_NO_EXPORT ON CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_ZLIB ON CACHE BOOL "" FORCE)
set(ASSIMP_IGNORE_GIT_HASH ON CACHE BOOL "" FORCE)

FetchContent_Declare(
    assimp
    GIT_REPOSITORY https://github.com/assimp/assimp.git
    GIT_TAG v5.4.3
)

FetchContent_MakeAvailable(glm xxhash_cpp assimp)

# Sources
set(SOURCES
    main.cpp
    includes.h
    structs.h
    helper.hpp
    bvh.hpp
    kdtree.hpp
)

add_executable(ModelConverter ${SOURCES})

target_link_libraries(ModelConverter PRIVATE assimp::assimp)

target_include_directories(ModelConverter PRIVATE
    ${glm_SOURCE_DIR}
    ${xxhash_cpp_SOURCE_DIR}/include
)

# Windows SDK libs (matches original VS project)
if(WIN32)
    target_link_libraries(ModelConverter PRIVATE
        kernel32.lib user32.lib gdi32.lib winspool.lib
        comdlg32.lib advapi32.lib shell32.lib ole32.lib
        oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
    )
endif()
