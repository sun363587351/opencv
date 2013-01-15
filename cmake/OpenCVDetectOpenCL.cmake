if(APPLE)
  set(OPENCL_FOUND YES)
  set(OPENCL_LIBRARIES "-framework OpenCL")
else()
  find_package(OpenCL QUIET)
  if(WITH_OPENCLAMDFFT)
    set(CLAMDFFT_SEARCH_PATH $ENV{CLAMDFFT_PATH})
    if(NOT CLAMDFFT_SEARCH_PATH)
      if(WIN32)
        set( CLAMDFFT_SEARCH_PATH "C:\\Program Files (x86)\\AMD\\clAmdFft" )
      endif()
    endif()
    set( CLAMDFFT_INCLUDE_SEARCH_PATH ${CLAMDFFT_SEARCH_PATH}/include )
    if(UNIX)
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(CLAMDFFT_LIB_SEARCH_PATH /usr/lib)
      else()
        set(CLAMDFFT_LIB_SEARCH_PATH /usr/lib64)
      endif()
    else()
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(CLAMDFFT_LIB_SEARCH_PATH ${CLAMDFFT_SEARCH_PATH}\\lib32\\import)
      else()
        set(CLAMDFFT_LIB_SEARCH_PATH ${CLAMDFFT_SEARCH_PATH}\\lib64\\import)
      endif()
    endif()
    find_path(CLAMDFFT_INCLUDE_DIR
      NAMES clAmdFft.h
      PATHS ${CLAMDFFT_INCLUDE_SEARCH_PATH}
      PATH_SUFFIXES clAmdFft
      NO_DEFAULT_PATH)
    find_library(CLAMDFFT_LIBRARY
      NAMES clAmdFft.Runtime
      PATHS ${CLAMDFFT_LIB_SEARCH_PATH}
      NO_DEFAULT_PATH)
    if(CLAMDFFT_LIBRARY)
      set(CLAMDFFT_LIBRARIES ${CLAMDFFT_LIBRARY})
    else()
      set(CLAMDFFT_LIBRARIES "")
    endif()
  endif()
  if(WITH_OPENCLAMDBLAS)
    set(CLAMDBLAS_SEARCH_PATH $ENV{CLAMDBLAS_PATH})
    if(NOT CLAMDBLAS_SEARCH_PATH)
      if(WIN32)
        set( CLAMDBLAS_SEARCH_PATH "C:\\Program Files (x86)\\AMD\\clAmdBlas" )
      endif()
    endif()
    set( CLAMDBLAS_INCLUDE_SEARCH_PATH ${CLAMDBLAS_SEARCH_PATH}/include )
    if(UNIX)
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(CLAMDBLAS_LIB_SEARCH_PATH /usr/lib)
      else()
        set(CLAMDBLAS_LIB_SEARCH_PATH /usr/lib64)
      endif()
    else()
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(CLAMDBLAS_LIB_SEARCH_PATH ${CLAMDBLAS_SEARCH_PATH}\\lib32\\import)
      else()
        set(CLAMDBLAS_LIB_SEARCH_PATH ${CLAMDBLAS_SEARCH_PATH}\\lib64\\import)
      endif()
    endif()
    find_path(CLAMDBLAS_INCLUDE_DIR
      NAMES clAmdBlas.h
      PATHS ${CLAMDBLAS_INCLUDE_SEARCH_PATH}
      PATH_SUFFIXES clAmdBlas
      NO_DEFAULT_PATH)
    find_library(CLAMDBLAS_LIBRARY
      NAMES clAmdBlas
      PATHS ${CLAMDBLAS_LIB_SEARCH_PATH}
      NO_DEFAULT_PATH)
    if(CLAMDBLAS_LIBRARY)
      set(CLAMDBLAS_LIBRARIES ${CLAMDBLAS_LIBRARY})
    else()
      set(CLAMDBLAS_LIBRARIES "")
    endif()
  endif()
  # Try AMD/ATI Stream SDK
  if (NOT OPENCL_FOUND)
    set(ENV_AMDSTREAMSDKROOT $ENV{AMDAPPSDKROOT})
    set(ENV_OPENCLROOT $ENV{OPENCLROOT})
    set(ENV_CUDA_PATH $ENV{CUDA_PATH})
    if(ENV_AMDSTREAMSDKROOT)
      set(OPENCL_INCLUDE_SEARCH_PATH ${ENV_AMDSTREAMSDKROOT}/include)
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} ${ENV_AMDSTREAMSDKROOT}/lib/x86)
      else()
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} ${ENV_AMDSTREAMSDKROOT}/lib/x86_64)
      endif()
    elseif(ENV_CUDA_PATH AND WIN32)
      set(OPENCL_INCLUDE_SEARCH_PATH ${ENV_CUDA_PATH}/include)
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} ${ENV_CUDA_PATH}/lib/Win32)
      else()
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} ${ENV_CUDA_PATH}/lib/x64)
      endif()
    elseif(ENV_OPENCLROOT AND UNIX)
      set(OPENCL_INCLUDE_SEARCH_PATH ${ENV_OPENCLROOT}/inc)
      if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} /usr/lib)
      else()
        set(OPENCL_LIB_SEARCH_PATH ${OPENCL_LIB_SEARCH_PATH} /usr/lib64)
      endif()
    endif()

    if(OPENCL_INCLUDE_SEARCH_PATH)
      find_path(OPENCL_INCLUDE_DIR
        NAMES CL/cl.h OpenCL/cl.h
        PATHS ${OPENCL_INCLUDE_SEARCH_PATH}
        NO_DEFAULT_PATH)
    else()
      find_path(OPENCL_INCLUDE_DIR
        NAMES CL/cl.h OpenCL/cl.h)
    endif()

    if(OPENCL_LIB_SEARCH_PATH)
      find_library(OPENCL_LIBRARY NAMES OpenCL PATHS ${OPENCL_LIB_SEARCH_PATH} NO_DEFAULT_PATH)
    else()
      find_library(OPENCL_LIBRARY NAMES OpenCL)
    endif()

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(
      OPENCL
      DEFAULT_MSG
      OPENCL_LIBRARY OPENCL_INCLUDE_DIR
      )

    if(OPENCL_FOUND)
      set(OPENCL_LIBRARIES ${OPENCL_LIBRARY})
      set(HAVE_OPENCL 1)
    else()
      set(OPENCL_LIBRARIES)
    endif()
  else()
    set(HAVE_OPENCL 1)
  endif()
endif()
