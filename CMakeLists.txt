cmake_minimum_required(VERSION 3.15)
project(cross-platform-hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(cross_platform_hello src/main.cpp)

if(MINGW AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_link_options(cross_platform_hello PRIVATE -static -static-libgcc -static-libstdc++)
endif()

install(TARGETS cross_platform_hello
        RUNTIME DESTINATION bin
        BUNDLE DESTINATION bin
        LIBRARY DESTINATION lib)
