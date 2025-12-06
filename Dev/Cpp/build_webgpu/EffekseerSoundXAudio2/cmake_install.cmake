# Install script for directory: C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/EffekseerSoundXAudio2

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files/Effekseer")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/EffekseerSoundXAudio2/EffekseerSoundXAudio2.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/Debug/EffekseerSoundXAudio2.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/Release/EffekseerSoundXAudio2.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/MinSizeRel/EffekseerSoundXAudio2.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/RelWithDebInfo/EffekseerSoundXAudio2.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EffekseerSoundXAudio2-config.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EffekseerSoundXAudio2-config.cmake"
         "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EffekseerSoundXAudio2-config-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EffekseerSoundXAudio2-config.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config-debug.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config-minsizerel.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config-relwithdebinfo.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/CMakeFiles/Export/c220ae0af1591e9e9e916bba91f25986/EffekseerSoundXAudio2-config-release.cmake")
  endif()
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/wrk/etherlords_pr_assets/packages/particles/Effekseer/Dev/Cpp/build_webgpu/EffekseerSoundXAudio2/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
