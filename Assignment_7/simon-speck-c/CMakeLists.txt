# ----------------------------------------------------------------------------
# Root CMake file for simon and speck
# ----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.7)

project(simon_speck CXX C)


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32 -fno-stack-protector -z execstack")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32 -fno-stack-protector -z execstack")

# ----------------------------------------------------------------------------
# simon speck options
# ----------------------------------------------------------------------------

# simon speck build components
# ===================================================
option(ENABLE_STATIC "Build a static version of the libraries?" OFF)
option(DISABLE_SHARED "Do not build a shared version of the libraries?" OFF)
option(ENABLE_CCACHE "Enable ccache?" ON)
option(ENABLE_TESTING "Enable testing?" OFF)

# simon speck build options
# ===================================================
option(ENABLE_NEON "Enable NEON instructions" OFF)
option(ENABLE_AVX2 "Enable AXV2 instructions" OFF)


# ----------------------------------------------------------------------------
# detect compiler and target platform architecture
# ----------------------------------------------------------------------------
# include(cmake/OpenCVDetectCXXCompiler.cmake)

# Add these standard paths to the search paths for FIND_LIBRARY
# to find libraries from these locations first
if(UNIX AND NOT ANDROID)
    if(X86_64 OR CMAKE_SIZEOF_VOID_P EQUAL 8)
        if(EXISTS /lib64)
            list(APPEND CMAKE_LIBRARY_PATH /lib64)
        else()
            list(APPEND CMAKE_LIBRARY_PATH /lib)
        endif()
        if(EXISTS /usr/lib64)
            list(APPEND CMAKE_LIBRARY_PATH /usr/lib64)
        else()
            list(APPEND CMAKE_LIBRARY_PATH /usr/lib)
        endif()
    elseif(X86 OR CMAKE_SIZEOF_VOID_P EQUAL 4)
        if(EXISTS /lib32)
            list(APPEND CMAKE_LIBRARY_PATH /lib32)
        else()
            list(APPEND CMAKE_LIBRARY_PATH /lib)
        endif()
        if(EXISTS /usr/lib32)
            list(APPEND CMAKE_LIBRARY_PATH /usr/lib32)
        else()
            list(APPEND CMAKE_LIBRARY_PATH /usr/lib)
        endif()
    endif()
endif()



# ----------------------------------------------------------------------------
# ccache
# ----------------------------------------------------------------------------
find_program(CCACHE_EXE ccache)
if(CCACHE_EXE)
  if(ENABLE_CCACHE)
    message(STATUS "Enable ccache")
    if(CMAKE_C_COMPILER_LAUNCHER)
      set(CMAKE_C_COMPILER_LAUNCHER "${CMAKE_C_COMPILER_LAUNCHER}" "${CCACHE_EXE}")
    else()
      set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_EXE}")
    endif()
    if(CMAKE_CXX_COMPILER_LAUNCHER)
      set(CMAKE_CXX_COMPILER_LAUNCHER "${CMAKE_CXX_COMPILER_LAUNCHER}" "${CCACHE_EXE}")
    else()
      set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_EXE}")
    endif()
  endif()
endif()




#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 11)



# Intel AVX2
if(ENABLE_AVX2)
    if(MSVC)
      set(avx2_flags "/arch:AVX2")
    else()
      set(avx2_flags "-mavx2")
    endif()
    try_run(AVX_RUN AVX_FOUND "${CMAKE_CURRENT_BINARY_DIR}" "${CMAKE_SOURCE_DIR}/cmake/checks/cpu_avx2.c"
      COMPILE_DEFINITIONS "${avx2_flags}")

    if(AVX_FOUND AND (AVX_RUN EQUAL 0))
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${avx2_flags}")
      set(WITH_AVX2 ON)
    endif()
endif()


# source
set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_common.c)
if(WITH_NEON)
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_neon.c)
    set(libspeck_PRIVATE_HEADER ${libspeck_PRIVATE_HEADER} src/speck/speck_neon_private.h)
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_ctr_neon.c)
elseif(WITH_AVX2)
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_avx2.c)
    set(libspeck_PRIVATE_HEADER ${libspeck_PRIVATE_HEADER} src/speck/speck_avx2_private.h)
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_ctr_avx2.c)
else()
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck.c)
    set(libspeck_SRCS ${libspeck_SRCS} src/speck/speck_ctr.c)
endif()



# header
set(libspeck_PUBLIC_HEADER include/speck/speck.h)
set(libspeck_PRIVATE_HEADER ${libspeck_PRIVATE_HEADER} src/speck/speck_private.h src/speck/speck_ctr_private.h)

include_directories(${CMAKE_SOURCE_DIR}/include)
set(libspeck_SRCS ${libspeck_SRCS} ${libspeck_PUBLIC_HEADER} ${libspeck_PRIVATE_HEADER})

add_library(speck
        SHARED
        ${libspeck_SRCS}
        )

if (WITH_NEON)
    target_compile_definitions(speck PRIVATE "-DWITH_NEON")
endif()


if (DISABLE_SHARED)
    add_library(libspeck STAIC ${libspeck_SRCS})
else (DISABLE_SHARED)
    add_library(libspeck SHARED ${libspeck_SRCS})
endif (DISABLE_SHARED)

SET_TARGET_PROPERTIES(libspeck PROPERTIES OUTPUT_NAME "speck")

if (ENABLE_STATIC AND NOT DISABLE_SHARED)
    add_library(libspeck_static STATIC ${libspeck_SRCS})
    set_target_properties(libspeck_static PROPERTIES OUTPUT_NAME "speck")
endif (ENABLE_STATIC AND NOT DISABLE_SHARED)




if (NOT (IOS OR ANDROID))
    add_executable(SSCrypter sample/SSCrypter.cpp)
#	I compile this manually
#    add_executable(SSExecuteShellcode sample/SSExecuteShellcode)
    target_link_libraries(SSCrypter PUBLIC speck)
#    target_link_libraries(SSExecuteShellcode PUBLIC speck)
endif()



