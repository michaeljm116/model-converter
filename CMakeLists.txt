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

# Assimp - Open Asset Import Library
set(ASSIMP_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_ASSIMP_TOOLS OFF CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_SAMPLES OFF CACHE BOOL "" FORCE)
set(ASSIMP_NO_EXPORT ON CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_ZLIB ON CACHE BOOL "" FORCE)
set(ASSIMP_IGNORE_GIT_HASH ON CACHE BOOL "" FORCE)
set(ASSIMP_INSTALL OFF CACHE BOOL "" FORCE)
set(ASSIMP_WARNINGS_AS_ERRORS OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
    assimp
    GIT_REPOSITORY https://github.com/assimp/assimp.git
    GIT_TAG v5.4.3
)

# macOS: use system zlib (assimp's vendored zlib doesn't build with Apple Clang 21+)
if(APPLE)
  set(ASSIMP_BUILD_ZLIB OFF CACHE BOOL "" FORCE)
  find_package(ZLIB QUIET)
  if(ZLIB_FOUND)
    message(STATUS "Using system ZLIB: ${ZLIB_INCLUDE_DIRS} / ${ZLIB_LIBRARIES}")
  else()
    message(WARNING "System ZLIB not found. Ensure zlib is installed (e.g., brew install zlib).")
  endif()
endif()

FetchContent_MakeAvailable(glm assimp)

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

target_compile_definitions(ModelConverter PRIVATE GLM_ENABLE_EXPERIMENTAL)

target_include_directories(ModelConverter PRIVATE
    ${glm_SOURCE_DIR}
)

# Windows SDK libs (matches original VS project)
if(WIN32)
    target_link_libraries(ModelConverter PRIVATE
        kernel32.lib user32.lib gdi32.lib winspool.lib
        comdlg32.lib advapi32.lib shell32.lib ole32.lib
        oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
    )
endif()
