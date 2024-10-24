echo on
setlocal

:: author: Seongcheol Jeon
:: created at: 2024-10-25
:: modified at: 2024-10-25
:: description: C++ Build Script for Windows

set _OLD_PATH=%cd%
set _LIB_PATH=C:\developments\OpenUSD
set _BUILD_TYPE=Release
set _CPP_VERSION=17
set _PYTHON_VERSION=3.11
set _PYTHON_EXECUTABLE=C:\Users\d2306010001\.pyenv\pyenv-win\versions\3.11.9\python3.exe


:: Python package
pip install numpy pytest
pip install PyOpenGL PyOpenGL_accelerate


:: fmt
git clone https://github.com/fmtlib/fmt.git .\fmt
cd fmt
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: glfw
git clone https://github.com/glfw/glfw.git .\glfw
cd glfw
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: glad
git clone https://github.com/Dav1dde/glad.git .\glad
cd %_OLD_PATH%


:: zlib
git clone https://github.com/madler/zlib .\zlib
cd zlib
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: IntelTBB
git clone https://github.com/oneapi-src/oneTBB.git .\onetbb
cd onetbb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DTBB_TEST=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: boost
:: TODO: boost에서 파이썬 못 찾는 문제 해결해야 함.
git clone --recurse-submodules https://github.com/boostorg/boost.git .\boost
cd boost
git checkout boost-1.82.0
git submodule update
.\bootstrap.bat --with-python=python%_PYTHON_EXECUTABLE% --prefix=%_LIB_PATH%
.\b2 install cxxflags="-std=c++17" --with-python --prefix=%_LIB_PATH% -j%NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: pybind11
git clone https://github.com/pybind/pybind11.git .\pybind11
cd pybind11
git checkout v2.13.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DPYBIND11_NUMPY_1_ONLY=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: libdeflate
git clone https://github.com/ebiggers/libdeflate.git .\libdeflate
cd libdeflate
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: Imath
git clone https://github.com/AcademySoftwareFoundation/Imath.git .\imath
cd imath
git checkout v3.1.9
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DPYTHON=ON -DBoost_NO_BOOST_CMAKE=OFF -DCMAKE_PREFIX_PATH="%_LIB_PATH%;C:\Users\d2306010001\.pyenv\pyenv-win\versions\3.11.9" -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenEXR
git clone https://github.com/AcademySoftwareFoundation/openexr.git .\openexr
cd openexr
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DOPENEXR_BUILD_PYTHON=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenSubdiv
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git .\opensubdiv
cd opensubdiv
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -D NO_PTEX=1 -D NO_DOC=1 -D NO_OMP=1 -D NO_TBB=1 -D NO_CUDA=1 -D NO_OPENCL=1 -D NO_CLEW=1 -D GLFW_LOCATION=C:\path\to\libglfw3.a -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenColorIO
git clone https://github.com/AcademySoftwareFoundation/OpenColorIO.git .\opencolorio
cd opencolorio
git checkout v2.1.3
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DBUILD_SHARED_LIBS=OFF -DOCIO_BUILD_APPS=ON -DOCIO_BUILD_PYTHON=ON -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: alembic
git clone https://github.com/alembic/alembic.git .\alembic
cd alembic
git checkout 1.8.5
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DUSE_PYALEMBIC=ON -DPYALEMBIC_PYTHON_MAJOR=3 -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: c-blosc
git clone https://github.com/Blosc/c-blosc.git .\c-blosc
cd c-blosc
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: Eigen3
@REM pybind11 설치하면서 같이 설치됨.
@REM git clone https://gitlab.com/libeigen/eigen.git .\eigen
@REM cd eigen
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
@REM cd %_OLD_PATH%


:: nanobind
git clone https://github.com/wjakob/nanobind.git .\nanobind
cd nanobind
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenVDB
git clone https://github.com/AcademySoftwareFoundation/openvdb.git .\openvdb
cd openvdb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DOPENVDB_BUILD_PYTHON_MODULE=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DOPENVDB_BUILD_NANOVDB=ON -DNANOVDB_USE_OPENVDB=ON -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: PTex
git clone https://github.com/wdas/ptex.git .\ptex
cd ptex
git checkout v2.4.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: Embree
git clone https://github.com/RenderKit/embree.git .\embree
cd embree
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: Draco
git clone https://github.com/google/draco.git .\draco
cd draco
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: MaterialX
git clone https://github.com/AcademySoftwareFoundation/MaterialX.git .\materialx
cd materialx
git submodule update --init --recursive 
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DMATERIALX_BUILD_PYTHON=ON -DMATERIALX_BUILD_VIEWER=ON -DMATERIALX_BUILD_GRAPH_EDITOR=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenShadingLanguage
git clone https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git .\osl
cd osl
:: 여기에서 OSL 관련 빌드 명령어를 추가해야 할 수 있습니다.
cd %_OLD_PATH%


:: OpenUSD
git clone https://github.com/PixarAnimationStudios/OpenUSD.git .\openusd
cd openusd
:: 여기에서 OpenUSD 관련 빌드 명령어를 추가해야 할 수 있습니다.
cd %_OLD_PATH%


:: OpenImageIO
@REM TODO: 나중에 빌드. 
:: libTIFF
@REM git clone https://gitlab.com/libtiff/libtiff.git .\libtiff
@REM cd libtiff
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DBUILD_SHARED_LIBS=OFF -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
@REM cd %_OLD_PATH%

:: libjpeg-turbo
@REM git clone https://github.com/libjpeg-turbo/libjpeg-turbo .\libjpeg-turbo
@REM cd libjpeg-turbo
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DENABLE_SHARED=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
@REM cd %_OLD_PATH%



endlocal


