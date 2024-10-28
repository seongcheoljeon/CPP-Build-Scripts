echo on
setlocal

:: author: Seongcheol Jeon
:: created at: 2024-10-25
:: modified at: 2024-10-25
:: description: C++ Build Script for Windows

set _OLD_PATH=%cd%
set _LIB_PATH=C:\\developments\\OpenUSD
set _BUILD_TYPE=Release
set _CPP_VERSION=17
set _PYTHON_VERSION=3.10
set _PYTHON_ROOT=C:\\Users\\d2306010001\\.pyenv\\pyenv-win\\versions\\3.10.10
set _PYTHON_EXECUTABLE=%_PYTHON_ROOT%\\python3.exe
set _PYTHON_INCLUDE=%_PYTHON_ROOT%\\include
set _PYTHON_LIBS=%_PYTHON_ROOT%\\libs

set _TBB_ROOT_DIR=C:/Users/d2306010001/source/repos/usd/onetbb
set _TBB_INCLUDE_DIR=%_TBB_ROOT_DIR%/include
set _TBB_LIBRARY=%_TBB_ROOT_DIR%/build/windows_intel64_cl_vc14_release

set _UNF_LIB_PATH=./dist

set PATH=%_PYTHON_ROOT%\\Scripts;%PATH%

:: -DCMAKE_TOOLCHAIN_FILE=C:/developments/vcpkg/scripts/buildsystems/vcpkg.cmake


:: Python package
pip install numpy==1.25 
pip install pytest PySide2 typing_extensions jinja2
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


:: IntelTBB
:: v2020.3은 cmake 빌드할 필요 없음.
:: TODO: 이거 빌드하면 usd에서 에러 발생하는듯...
git clone https://github.com/oneapi-src/oneTBB.git .\onetbb
cd onetbb
git checkout v2020.3
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DTBB_TEST=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: zlib
git clone https://github.com/madler/zlib.git .\zlib
cd zlib
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: boost
:: project-config.jam 파일에 파이썬 경로 추가해야 함.
:: using python 
::  : 3.10 
::  : C:\\Users\\d2306010001\\.pyenv\\pyenv-win\\versions\\3.10.10\\python3.exe 
::  : C:\\Users\\d2306010001\\.pyenv\\pyenv-win\\versions\\3.10.10\\include 
::  : C:\\Users\\d2306010001\\.pyenv\\pyenv-win\\versions\\3.10.10\\libs 
::  : <address-model>64
::  ;

:: link 기본값은 static
:: b2 install link=static cxxflags="-std=c++17" address-model=64 --build-type=complete --prefix=%_LIB_PATH%/static -j%NUMBER_OF_PROCESSORS%
:: b2 install link=shared cxxflags="-std=c++17" address-model=64 --build-type=complete --prefix=%_LIB_PATH%/dynamic -j%NUMBER_OF_PROCESSORS%

git clone --recurse-submodules https://github.com/boostorg/boost.git .\boost
cd boost
git checkout boost-1.82.0
git submodule update
.\bootstrap.bat --with-toolset=msvc --with-python=python%_PYTHON_EXECUTABLE% --prefix=%_LIB_PATH%
.\b2 install cxxflags="-std=c++17" address-model=64 --build-type=complete --prefix=%_LIB_PATH% -j%NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: pybind11
git clone https://github.com/pybind/pybind11.git .\pybind11
cd pybind11
git checkout v2.13.6
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DPYBIND11_NUMPY_1_ONLY=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: Imath
:: TODO: python 빌드 안됨. 그래서 OFF로 설정함.
@REM git clone https://github.com/AcademySoftwareFoundation/Imath.git .\imath
@REM cd imath
@REM git checkout v3.1.7
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DPYTHON=ON -DBoost_NO_BOOST_CMAKE=OFF -DPYBIND11=ON -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DIMATH_CXX_STANDARD=%_CPP_VERSION% -DCMAKE_CXX_FLAGS="/bigobj" -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
@REM cd %_OLD_PATH%


:: libdeflate
git clone https://github.com/ebiggers/libdeflate.git .\libdeflate
cd libdeflate
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenEXR
:: openexr에서 imath 자동으로 다운로드하고 설치함
git clone https://github.com/AcademySoftwareFoundation/openexr.git .\openexr
cd openexr
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DOPENEXR_BUILD_PYTHON=OFF -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DOPENEXR_INSTALL_DOCS=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DBUILD_WEBSITE=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: PTex
git clone https://github.com/wdas/ptex.git .\ptex
cd ptex
git checkout v2.4.3
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenSubdiv
git clone https://github.com/PixarAnimationStudios/OpenSubdiv.git .\opensubdiv
cd opensubdiv
git checkout v3_6_0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DNO_PTEX=OFF -DNO_DOC=ON -DNO_OMP=ON -DNO_TBB=ON -DNO_CUDA=OFF -DNO_OPENCL=ON -DNO_CLEW=ON -DGLFW_LOCATION=C:\developments\OpenUSD\lib\glfw3.lib -DBUILD_SHARED_LIBS=OFF -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -A x64 -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
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
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DUSE_PYALEMBIC=OFF -DPYALEMBIC_PYTHON_MAJOR=3 -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_TOOLCHAIN_FILE=C:/developments/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
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
git submodule update --init --recursive
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenVDB
git clone https://github.com/AcademySoftwareFoundation/openvdb.git .\openvdb
cd openvdb
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DOPENVDB_BUILD_PYTHON_MODULE=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DOPENVDB_BUILD_NANOVDB=ON -DNANOVDB_USE_OPENVDB=ON -DTBB_ROOT=%_TBB_ROOT_DIR% -DTBB_INCLUDEDIR=%_TBB_INCLUDE_DIR% -DTBB_LIBRARYDIR=%_TBB_LIBRARY% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


@REM :: Embree
@REM git clone https://github.com/RenderKit/embree.git .\embree
@REM cd embree
@REM git checkout v4.2.0
@REM cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DTBB_INCLUDE_DIR=%_TBB_INCLUDE_DIR% -DTBB_ROOT=%_TBB_ROOT_DIR% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
@REM cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
@REM cd %_OLD_PATH%


:: Draco
git clone https://github.com/google/draco.git .\draco
cd draco
git checkout 1.5.6
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DBUILD_SHARED_LIBS=ON -DPYTHON_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: MaterialX
git clone https://github.com/AcademySoftwareFoundation/MaterialX.git .\materialx
cd materialx
git checkout v1.39.1
git submodule update --init --recursive 
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DMATERIALX_BUILD_PYTHON=ON -DMATERIALX_BUILD_VIEWER=ON -DMATERIALX_BUILD_GRAPH_EDITOR=ON -DPYBIND11_FINDPYTHON=ON -DPython_EXECUTABLE=%_PYTHON_EXECUTABLE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: OpenShadingLanguage
git clone https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git .\osl
cd osl
:: 여기에서 OSL 관련 빌드 명령어를 추가해야 할 수 있습니다.
cd %_OLD_PATH%


:: bison


:: OpenUSD
git clone https://github.com/PixarAnimationStudios/OpenUSD.git .\openusd
cd openusd
git checkout v24.05
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DPython3_EXECUTABLE=%_PYTHON_EXECUTABLE%  -DPXR_VALIDATE_GENERATED_CODE=OFF -DPXR_BUILD_ALEMBIC_PLUGIN=ON -DPXR_ENABLE_PTEX_SUPPORT=OFF -DPXR_BUILD_DRACO_PLUGIN=ON -DPXR_BUILD_GPU_SUPPORT=ON -DPXR_ENABLE_VULKAN_SUPPORT=OFF -DTBB_ROOT_DIR=%_TBB_ROOT_DIR% -DTBB_INCLUDE_DIR=%_TBB_INCLUDE_DIR% -DTBB_LIBRARY=%_TBB_LIBRARY% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: GoogleTest
git clone https://github.com/google/googletest.git .\googletest
cd googletest
git checkout v1.15.2
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


:: USD Notify Framework
:: TODO: 빌드되는 곳을 ./dist로 설정함.
git clone https://github.com/wdas/unf.git .\unf
cd unf
git checkout 0.7.0
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_UNF_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_PREFIX_PATH=%_LIB_PATH% -DBUILD_PYTHON_BINDINGS=ON -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DPython_ROOT=%_PYTHON_ROOT% -DUSD_ROOT=%_LIB_PATH% -DBoost_ROOT=%_LIB_PATH% -DTBB_ROOT_DIR=%_TBB_ROOT_DIR% -DTBB_INCLUDE_DIR=%_TBB_INCLUDE_DIR% -DTBB_LIBRARY=%_TBB_LIBRARY% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


endlocal
