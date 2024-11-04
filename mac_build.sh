#!/bin/bash

# author: Seongcheol Jeon
# created at: 2024-11-04
# modified at: 2024-11-04
# description: C++ Build Script for MacOS
# OpenUSD Version: 24.03


_OLD_PATH=$(pwd)
_SRC_PATH=${HOME}/source/usd
_LIB_PATH=${HOME}/developments/OpenUSD
_BUILD_TYPE=Release
_CPP_VERSION=17
_PYTHON_MAJOR_VERSION=3
_PYTHON_MINOR_VERSION=11
_PYTHON_PATCH_VERSION=10
_PYTHON_VERSION=${_PYTHON_MAJOR_VERSION}.${_PYTHON_MINOR_VERSION}
_PYTHON_ROOT=${HOME}/.pyenv/versions/${_PYTHON_VERSION}.${_PYTHON_PATCH_VERSION}
_PYTHON_EXECUTABLE=${_PYTHON_ROOT}/bin/python${_PYTHON_MAJOR_VERSION}
_PYTHON_INCLUDE=${_PYTHON_ROOT}/include/python${_PYTHON_VERSION}
_PYTHON_LIBS=${_PYTHON_ROOT}/lib

_TBB_ROOT_DIR=${_SRC_PATH}/onetbb
_TBB_INCLUDE_DIR=${_TBB_ROOT_DIR}/include
# TODO: 수정
_TBB_LIBRARY=${_TBB_ROOT_DIR}/build/macos_intel64_clang_cc15.0.0_os13.7.1_release

_GLFW_LIB_PATH=${_LIB_PATH}/lib/libglfw3.a

_NUM_OF_PROCESSORS=$(sysctl -n hw.ncpu)

# UIC, RCC 때문에 PATH에 추가함.
export PATH=${_PYTHON_ROOT}/bin:${PATH}

# ??
_BOOST_STATIC_BUILD_DIR=${_SRC_PATH}/boost/build_static
_BOOST_SHARED_BUILD_DIR=${_SRC_PATH}/boost/build_shared

_UNF_LIB_PATH=./dist

# -DCMAKE_TOOLCHAIN_FILE=${HOME}/vcpkg/scripts/buildsystems/vcpkg.cmake


# Python package
pip install numpy==1.25 
pip install pytest PySide2 typing_extensions jinja2
pip install PyOpenGL PyOpenGL_accelerate


# fmt
git clone https://github.com/fmtlib/fmt.git ./fmt
cd fmt
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# spdlog
git clone https://github.com/gabime/spdlog.git ./spdlog
cd spdlog
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DSPDLOG_BUILD_ALL=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# glfw
git clone https://github.com/glfw/glfw.git ./glfw
cd glfw
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# glad
git clone https://github.com/Dav1dde/glad.git ./glad
cd ${_OLD_PATH}


# IntelTBB
# v2020.3은 cmake 빌드할 필요 없음.
# TODO: 이거 빌드하면 usd에서 에러 발생하는듯...
git clone https://github.com/oneapi-src/oneTBB.git ./onetbb
cd onetbb
git checkout v2020.3
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DTBB_TEST=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# zlib
git clone https://github.com/madler/zlib.git ./zlib
cd zlib
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# boost

# link 기본값은 static
# b2 install link=static cxxflags="-std=c++17" address-model=64 --build-type=complete --prefix=${_LIB_PATH}/static -j${_NUM_OF_PROCESSORS}
# b2 install link=shared cxxflags="-std=c++17" address-model=64 --build-type=complete --prefix=${_LIB_PATH}/dynamic -j${_NUM_OF_PROCESSORS}
# --layout=system 옵션을 사용하면 Boost라이브러리 이름에서 컴파일러 버전 및 빌드 옵션 정보를 생략하여 일관된 파일 이름을 유지할 수 있다. 따라서 정적 및 동적 라이브러리 링크 단계에서 편리하다.

# !! git으로 받아서 설치하려고 하면 submodule이 없어서 에러가 발생한다. 그래서 직접 압축파일을 받아서 설치한다
# https://archives.boost.io/release/1.82.0/source/  여기서 압축파일을 받아서 설치한다.
#git clone --recurse-submodules https://github.com/boostorg/boost.git ./boost
#cd boost
#git checkout boost-1.82.0
#git submodule update
./bootstrap.sh --with-toolset=clang --with-python=python${_PYTHON_VERSION} --prefix=${_LIB_PATH}

# ./b2 install link=static cxxflags="-std=c++17" threading=multi address-model=64 --build-type=complete --build-dir=${_BOOST_STATIC_BUILD_DIR} --layout=system --prefix=${_LIB_PATH}/static -j${_NUM_OF_PROCESSORS}
# ./b2 install link=shared cxxflags="-std=c++17" threading=multi address-model=64 --build-type=complete --build-dir=${_BOOST_SHARED_BUILD_DIR} --layout=system --prefix=${_LIB_PATH}/shared -j${_NUM_OF_PROCESSORS}

./b2 install cxxflags="-std=c++17" threading=multi link=shared address-model=64 --build-type=complete --layout=versioned --prefix=${_LIB_PATH} -j${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# pybind11
# MaterialX에서 자동으로 설치됨.
# git clone https://github.com/pybind/pybind11.git ./pybind11
# cd pybind11
# git checkout v2.12.0
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPYBIND11_NUMPY_1_ONLY=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
# cd ${_OLD_PATH}


# Imath
# TODO: python 빌드 안됨. 그래서 OFF로 설정함.
git clone https://github.com/AcademySoftwareFoundation/Imath.git ./imath
cd imath
git checkout v3.1.12
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPYTHON=ON -DBoost_NO_BOOST_CMAKE=ON -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DIMATH_CXX_STANDARD=${_CPP_VERSION} -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# libdeflate
git clone https://github.com/ebiggers/libdeflate.git ./libdeflate
cd libdeflate
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# OpenEXR
# openexr에서 imath 자동으로 다운로드하고 설치함
git clone https://github.com/AcademySoftwareFoundation/openexr.git ./openexr
cd openexr
git checkout v3.2.4
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DOPENEXR_BUILD_PYTHON=OFF -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DOPENEXR_INSTALL_DOCS=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DBUILD_WEBSITE=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# PTex
git clone https://github.com/wdas/ptex.git ./ptex
cd ptex
git checkout v2.4.3
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# OpenSubdiv
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git ./opensubdiv
cd opensubdiv
git checkout v3_6_0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DNO_PTEX=ON -DNO_DOC=ON -DNO_OMP=ON -DNO_REGRESSION=OFF -DNO_TBB=ON -DNO_CUDA=OFF -DNO_OPENCL=ON -DNO_CLEW=ON -DOPENGL_INCLUDE_DIR="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers" -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# OpenColorIO
git clone https://github.com/AcademySoftwareFoundation/OpenColorIO.git ./opencolorio
cd opencolorio
git checkout v2.3.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=OFF -DOCIO_BUILD_APPS=ON -DOCIO_BUILD_PYTHON=ON -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# alembic
git clone https://github.com/alembic/alembic.git ./alembic
cd alembic
git checkout 1.8.5
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DUSE_PYALEMBIC=OFF -DPYALEMBIC_PYTHON_MAJOR=3 -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# c-blosc
git clone https://github.com/Blosc/c-blosc.git ./c-blosc
cd c-blosc
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# Eigen3
# pybind11 설치하면서 같이 설치됨.
# git clone https://gitlab.com/libeigen/eigen.git ./eigen
# cd eigen
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
# cd ${_OLD_PATH}


# nanobind
git clone https://github.com/wjakob/nanobind.git ./nanobind
cd nanobind
git submodule update --init --recursive
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# OpenVDB
git clone https://github.com/AcademySoftwareFoundation/openvdb.git ./openvdb
cd openvdb
git checkout v11.0.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DBoost_USE_STATIC_LIBS=OFF -DOPENVDB_BUILD_PYTHON_MODULE=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DOPENVDB_BUILD_NANOVDB=ON -DNANOVDB_USE_OPENVDB=ON -DTBB_ROOT=${_TBB_ROOT_DIR} -DTBB_INCLUDEDIR=${_TBB_INCLUDE_DIR} -DTBB_LIBRARYDIR=${_TBB_LIBRARY} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# # Embree
# git clone https://github.com/RenderKit/embree.git ./embree
# cd embree
# git checkout v4.2.0
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DTBB_INCLUDE_DIR=${_TBB_INCLUDE_DIR} -DTBB_ROOT=${_TBB_ROOT_DIR} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
# cd ${_OLD_PATH}


# Draco
git clone https://github.com/google/draco.git ./draco
cd draco
git checkout 1.5.6
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DBUILD_SHARED_LIBS=ON -DPYTHON_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# MaterialX
git clone https://github.com/AcademySoftwareFoundation/MaterialX.git ./materialx
cd materialx
git checkout v1.38.7
git submodule update --init --recursive 
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DNANOGUI_BUILD_PYTHON=ON -DMATERIALX_BUILD_PYTHON=ON -DMATERIALX_BUILD_VIEWER=ON -DMATERIALX_BUILD_GRAPH_EDITOR=ON -DPYBIND11_FINDPYTHON=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# OpenShadingLanguage
git clone https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git ./osl
cd osl
# 여기에서 OSL 관련 빌드 명령어를 추가해야 할 수 있습니다.
cd ${_OLD_PATH}


# bison


# OpenUSD
git clone https://github.com/PixarAnimationStudios/OpenUSD.git ./openusd
cd openusd
git checkout v24.03
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE}  -DPXR_VALIDATE_GENERATED_CODE=OFF -DPXR_BUILD_ALEMBIC_PLUGIN=ON -DPXR_ENABLE_MATERIALX_SUPPORT=OFF -DPXR_BUILD_GPU_SUPPORT=ON -DPXR_ENABLE_VULKAN_SUPPORT=OFF -DPXR_BUILD_PYTHON_DOCUMENTATION=ON -DPXR_ENABLE_OPENVDB_SUPPORT=ON -DTBB_ROOT_DIR=${_TBB_ROOT_DIR} -DTBB_INCLUDE_DIR=${_TBB_INCLUDE_DIR} -DTBB_LIBRARY=${_TBB_LIBRARY} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# GoogleTest
git clone https://github.com/google/googletest.git ./googletest
cd googletest
git checkout v1.15.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


# USD Notify Framework
# TODO: 빌드되는 곳을 ./dist로 설정함.
git clone https://github.com/wdas/unf.git ./unf
cd unf
git checkout 0.7.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_UNF_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DBUILD_PYTHON_BINDINGS=ON -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DPython_ROOT=${_PYTHON_ROOT} -DUSD_ROOT=${_LIB_PATH} -DBoost_ROOT=${_LIB_PATH} -DTBB_ROOT_DIR=${_TBB_ROOT_DIR} -DTBB_INCLUDE_DIR=${_TBB_INCLUDE_DIR} -DTBB_LIBRARY=${_TBB_LIBRARY} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j ${_NUM_OF_PROCESSORS}
cd ${_OLD_PATH}


endlocal
