echo on
setlocal

rem author: Seongcheol Jeon
rem created at: 2024-10-25
rem modified at: 2024-10-25
rem description: C++ Build Script for Windows

set "_OLD_PATH=%cd%"
set "_LIB_PATH=C:\developments\library"
set "_BUILD_TYPE=Release"
set "_CPP_VERSION=17"

rem Python package
pip install numpy
pip install PyOpenGL PyOpenGL_accelerate


rem fmt
git clone https://github.com/fmtlib/fmt.git fmt
cd fmt
cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=%_LIB_PATH% -DCMAKE_BUILD_TYPE=%_BUILD_TYPE% -DCMAKE_CXX_STANDARD=%_CPP_VERSION%
cmake --build build --config %_BUILD_TYPE% --target install -j %NUMBER_OF_PROCESSORS%
cd %_OLD_PATH%


endlocal