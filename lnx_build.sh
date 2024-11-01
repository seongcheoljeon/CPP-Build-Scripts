#!/bin/bash

# author: Seongcheol Jeon
# created at: 2024-10-25
# modified at: 2024-10-25
# description: C++ Build Script for Linux
# example:
#   export PYTHONPATH=$PYTHONPATH:/home/<user>/sources/USD/OpenUSD/dist/lib/python
#   export LD_LIBRARY_PATH=/home/<user>/sources/USD/OpenUSD/dist/lib:/home/<user>/sources/boost/build/lib:$LD_LIBRARY_PATH
#   ./usdview <usd file>



_OLD_PATH=$(pwd)
_LIB_PATH="/home/user/development/library"
_BUILD_TYPE="Release"
_CPP_VERSION="17"
_PYTHON_VERSION=3.10
_PYTHON_ROOT=/usr/local/pyenv/versions/3.10.10
_PYTHON_EXECUTABLE=${_PYTHON_ROOT}/bin/python3


# python package
pip install numpy pytest
pip install PyOpenGL PyOpenGL_accelerate


# fmt
git clone https://github.com/fmtlib/fmt.git ./fmt
cd fmt
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# spdlog
git clone https://github.com/gabime/spdlog.git ./spdlog
cd spdlog
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DSPDLOG_BUILD_ALL=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# glfw
git clone https://github.com/glfw/glfw.git ./glfw
cd glfw
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# glad
# TODO: cmake 빌드를 해야 하나?
git clone https://github.com/Dav1dde/glad.git ./glad
cd ${_OLD_PATH}


# vulkan
# dnf로 설치함


# IntelTBB
# v2020.3은 cmake 빌드할 필요 없음.
git clone https://github.com/oneapi-src/oneTBB.git ./onetbb
cd onetbb
git checkout v2020.3
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DTBB_TEST=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# boost
git clone --recurse-submodules https://github.com/boostorg/boost.git ./boost
cd boost
git checkout boost-1.85.0
git submodule update
./bootstrap.sh --with-python=python${_PYTHON_VERSION} --prefix=${_LIB_PATH}
./b2 install cxxflags="-std=c++17" --build-type=complete --prefix=${_LIB_PATH} -j$(nproc)
cd ${_OLD_PATH}


# pybind11
git clone https://github.com/pybind/pybind11.git ./pybind11
cd pybind11
git checkout v2.10.4
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPYBIND11_NUMPY_1_ONLY=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# libdeflate
git clone https://github.com/ebiggers/libdeflate.git ./libdeflate
cd libdeflate
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# Imath
git clone https://github.com/AcademySoftwareFoundation/Imath.git ./imath
cd imath
git checkout v3.1.7
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DPYTHON=ON -DBoost_NO_BOOST_CMAKE=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd  


# OpenEXR
git clone https://github.com/AcademySoftwareFoundation/openexr.git ./openexr
cd openexr
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DOPENEXR_BUILD_PYTHON=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# PTex
git clone https://github.com/wdas/ptex.git ./ptex
cd ptex
git checkout v2.4.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenSubdiv
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git ./opensubdiv
cd opensubdiv
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DNO_PTEX=OFF -DNO_DOC=ON -DNO_OMP=ON -DNO_TBB=ON -DNO_CUDA=ON -DNO_OPENCL=ON -DNO_CLEW=ON -DGLFW_LOCATION=/home/user/development/library/lib64/libglfw3.a -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenColorIO
git clone https://github.com/AcademySoftwareFoundation/OpenColorIO.git ./opencolorio
cd opencolorio
git checkout v2.1.3
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=OFF -DOCIO_BUILD_APPS=ON -DOCIO_BUILD_PYTHON=ON -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# alembic
git clone https://github.com/alembic/alembic.git ./alembic
cd alembic
git checkout 1.8.5
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DUSE_PYALEMBIC=ON -DPYALEMBIC_PYTHON_MAJOR=3 -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# c-blosc
git clone https://github.com/Blosc/c-blosc.git ./c-blosc
cd c-blosc
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# Eigen3
# TODO: 위에서 설치해서? 또 설치할 필요 없음.
# git clone https://gitlab.com/libeigen/eigen.git ./eigen
# cd eigen
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
# cd ${_OLD_PATH}


# nanobind
git clone https://github.com/wjakob/nanobind.git ./nanobind
cd nanobind
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenVDB
git clone https://github.com/AcademySoftwareFoundation/openvdb.git ./openvdb
cd openvdb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DOPENVDB_BUILD_PYTHON_MODULE=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DOPENVDB_BUILD_NANOVDB=ON -DNANOVDB_USE_OPENVDB=ON -DTBB_ROOT=/home/user/sources/onetbb -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# Embree
git clone https://github.com/RenderKit/embree.git ./embree
cd embree
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# Draco
git clone https://github.com/google/draco.git ./draco
cd draco
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# MaterialX
git clone https://github.com/AcademySoftwareFoundation/MaterialX.git ./materialx
cd materialx
git submodule update --init --recursive 
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DMATERIALX_BUILD_PYTHON=ON -DMATERIALX_BUILD_VIEWER=ON -DMATERIALX_BUILD_GRAPH_EDITOR=ON -DPython_EXECUTABLE=${_PYTHON_EXECUTABLE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenShadingLanguage
# TODO: OpenImageIO 필요해서 설치 안됨.
# git clone https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git ./osl
# cd osl
# cd ${_OLD_PATH}


# OpenUSD
# Vulkan SDK 다운로드 : https://vulkan.lunarg.com/
git clone https://github.com/PixarAnimationStudios/OpenUSD.git ./openusd
cd openusd
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH="${_LIB_PATH};/home/user/development/vulkan-1.3.296.0/x86_64" -DPython3_EXECUTABLE=${_PYTHON_EXECUTABLE} -DPXR_VALIDATE_GENERATED_CODE=ON -DPXR_VALIDATE_GENERATED_CODE=ON -DPXR_BUILD_ALEMBIC_PLUGIN=ON -DPXR_BUILD_DRACO_PLUGIN=ON -DPXR_BUILD_GPU_SUPPORT=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# GoogleTest
git clone https://github.com/google/googletest.git ./googletest
cd googletest
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# USD Notice Framework
# dnf install doxygen
# pip install sphinxcontrib-doxylink sphinx_rtd_theme
# TODO: 다른 디렉토리에다가 설치하자!! 추후 이름 변경할 수 있으니!
git clone https://github.com/wdas/unf.git ./unf
cd unf
git checkout 0.7.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DUSD_ROOT=${_LIB_PATH} -DTBB_ROOT=/home/user/sources/onetbb -DBoost_ROOT=${_LIB_PATH} -DPython_ROOT=${_PYTHON_ROOT} -DCMAKE_PREFIX_PATH="${_LIB_PATH};/home/user/.local/share/Pytest;/home/user/.local/share/Sphinx" -DPYTEST_EXECUTABLE=/home/user/.local/bin/pytest -DSPHINX_EXECUTABLE=/home/user/.local/bin/sphinx-build
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}
