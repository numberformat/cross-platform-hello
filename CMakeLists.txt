cmake_minimum_required(VERSION 3.15)
project(cross-platform-hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(MIN_WX_VERSION 3.2)
set(USE_WXCONFIG_FALLBACK OFF)

find_package(wxWidgets ${MIN_WX_VERSION} COMPONENTS core base)

if(NOT wxWidgets_FOUND)
    if(wxWidgets_CONFIG_EXECUTABLE)
        message(STATUS "Falling back to wx-config: ${wxWidgets_CONFIG_EXECUTABLE}")
        execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --version
                        OUTPUT_VARIABLE WX_CONFIG_VERSION
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        if(WX_CONFIG_VERSION VERSION_LESS MIN_WX_VERSION)
            message(FATAL_ERROR "wx-config reports version ${WX_CONFIG_VERSION}, but >= ${MIN_WX_VERSION} is required.")
        endif()

        execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --cflags
                        OUTPUT_VARIABLE WX_CONFIG_CFLAGS
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --libs core,base
                        OUTPUT_VARIABLE WX_CONFIG_LIBS
                        OUTPUT_STRIP_TRAILING_WHITESPACE)

        separate_arguments(WX_CONFIG_CFLAGS)
        separate_arguments(WX_CONFIG_LIBS)

        set(USE_WXCONFIG_FALLBACK ON)
    else()
        message(FATAL_ERROR "wxWidgets ${MIN_WX_VERSION}+ is required but neither find_package nor wx-config succeeded.")
    endif()
else()
    if(wxWidgets_USE_FILE)
        include(${wxWidgets_USE_FILE})
    endif()
endif()

add_executable(cross_platform_hello src/main.cpp)

if(USE_WXCONFIG_FALLBACK)
    target_compile_options(cross_platform_hello PRIVATE ${WX_CONFIG_CFLAGS})
    target_link_libraries(cross_platform_hello PRIVATE ${WX_CONFIG_LIBS})
else()
    target_include_directories(cross_platform_hello PRIVATE ${wxWidgets_INCLUDE_DIRS})
    target_compile_definitions(cross_platform_hello PRIVATE ${wxWidgets_DEFINITIONS})
    target_link_libraries(cross_platform_hello PRIVATE ${wxWidgets_LIBRARIES})
endif()

if(MINGW)
    # Link the MinGW runtime statically so the Windows binary is fully self-contained.
    target_link_options(cross_platform_hello PRIVATE -static -static-libgcc -static-libstdc++)
endif()

install(TARGETS cross_platform_hello
        RUNTIME DESTINATION bin
        BUNDLE DESTINATION bin
        LIBRARY DESTINATION lib)
