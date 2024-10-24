#!/bin/bash


_OLD_PATH=$(PWD)
_LIB_PATH="/home/vfx/development/library"
_BUILD_TYPE="Release"
_CPP_VERSION="17"


# python package
pip install numpy
pip install PyOpenGL PyOpenGL_accelerate


# fmt
git clone https://github.com/fmtlib/fmt.git ./fmt
cd fmt
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# glfw
git clone https://github.com/glfw/glfw.git ./glfw
cd glfw
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# glad
# TODO: cmake 빌드를 해야 하나?
git clone https://github.com/Dav1dde/glad.git ./glad
cd ${_OLD_PATH}


# vulkan
# dnf로 설치함


# IntelTBB
git clone https://github.com/oneapi-src/oneTBB.git ./onetbb
cd onetbb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DTBB_TEST=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# boost
git clone --recurse-submodules https://github.com/boostorg/boost.git ./boost
cd boost
git checkout boost-1.82.0
git submodule update
./bootstrap.sh --with-python=python3.10 --prefix=${_LIB_PATH}
./b2 install cxxflags="-std=c++17" --prefix=${_LIB_PATH} -j$(nproc)
cd ${_OLD_PATH}


# pybind11
git clone https://github.com/pybind/pybind11.git ./pybind11
cd pybind11
git checkout v2.13.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPYBIND11_NUMPY_1_ONLY=ON -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DDOWNLOAD_CATCH=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
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
git checkout v3.1.9
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DPython3_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DPYTHON=ON -DBoost_NO_BOOST_CMAKE=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd  


# OpenEXR
git clone https://github.com/AcademySoftwareFoundation/openexr.git ./openexr
cd openexr
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython3_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DOPENEXR_BUILD_PYTHON=ON -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenSubdiv
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git ./opensubdiv
cd opensubdiv
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -D NO_PTEX=1 -D NO_DOC=1 -D NO_OMP=1 -D NO_TBB=1 -D NO_CUDA=1 -D NO_OPENCL=1 -D NO_CLEW=1 -D GLFW_LOCATION=/home/vfx/development/library/lib64/libglfw3.a -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenColorIO
git clone https://github.com/AcademySoftwareFoundation/OpenColorIO.git ./opencolorio
cd opencolorio
git checkout v2.1.3
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=ON -DOCIO_BUILD_APPS=ON -DOCIO_BUILD_PYTHON=ON -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


############################################################################
# OpenImageIO
# libtiff
git clone https://gitlab.com/libtiff/libtiff.git ./libtiff
cd libtiff
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DBUILD_SHARED_LIBS=OFF -DPython3_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}

# libjpeg-turbo
git clone https://github.com/libjpeg-turbo/libjpeg-turbo ./libjpeg-turbo
cd libjpeg-turbo
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DENABLE_SHARED=OFF -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}

# OpenCV
git clone https://github.com/opencv/opencv.git ./opencv
cd opencv
git checkout 4.9.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython3_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}

# OpenImageIO 
# TODO: 설치 안됨. (OpenColorIO, DCMTK, FFmpeg, GIF, Libheif, LibRaw, Jasper, LibRaw, OpenJPEG, OpenVDB, Ptex, WebP, oiio-images, openexr-images, fits-images, j2kp4files) 이것들 없어서 설치 안됨.
# TODO: 의존성 너무 많다. 나중에 빌드하자.
# git clone https://github.com/AcademySoftwareFoundation/OpenImageIO.git ./openimageio
# cd openimageio
# git checkout v2.5.8.0
# cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DUSE_PYTHON=1 -DUSE_QT=0 -DBUILD_SHARED_LIBS=0 -DLINKSTATIC=1 -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
# cd ${_OLD_PATH}
############################################################################


# alembic
git clone https://github.com/alembic/alembic.git ./alembic
cd alembic
git checkout 1.8.5
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DUSE_PYALEMBIC=ON -DPYALEMBIC_PYTHON_MAJOR=3 -DPython3_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# c-blosc
git clone https://github.com/Blosc/c-blosc.git ./c-blosc
cd c-blosc
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# Eigen3
git clone https://gitlab.com/libeigen/eigen.git ./eigen
cd eigen
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# nanobind
git clone https://github.com/wjakob/nanobind.git ./nanobind
cd nanobind
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenVDB
git clone https://github.com/AcademySoftwareFoundation/openvdb.git ./openvdb
cd openvdb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DOPENVDB_BUILD_PYTHON_MODULE=ON -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DOPENVDB_BUILD_NANOVDB=ON -DNANOVDB_USE_OPENVDB=ON -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# PTex
git clone https://github.com/wdas/ptex.git ./ptex
cd ptex
git checkout v2.4.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
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
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# MaterialX
git clone https://github.com/AcademySoftwareFoundation/MaterialX.git ./materialx
cd materialx
git submodule update --init --recursive 
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${_LIB_PATH} -DCMAKE_BUILD_TYPE=${_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${_LIB_PATH} -DMATERIALX_BUILD_PYTHON=ON -DMATERIALX_BUILD_VIEWER=ON -DMATERIALX_BUILD_GRAPH_EDITOR=ON -DPython_EXECUTABLE=/usr/local/pyenv/versions/3.10.10/bin/python3 -DCMAKE_CXX_STANDARD=${_CPP_VERSION}
cmake --build build --config ${_BUILD_TYPE} --target install -j$(nproc)
cd ${_OLD_PATH}


# OpenShadingLanguage
git clone https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git ./osl
cd osl

cd ${_OLD_PATH}


# OpenUSD
git clone https://github.com/PixarAnimationStudios/OpenUSD.git ./openusd
cd openusd

cd ${_OLD_PATH}