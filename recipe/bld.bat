setlocal EnableDelayedExpansion

copy %RECIPE_DIR%\CMakeLists.txt .\CMakeLists.txt
copy %RECIPE_DIR%\libtheora.def .\libtheora.def

:: Make a build folder and change to it.
mkdir build
cd build

:: Configure using the CMakeFiles
cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    .. 
if errorlevel 1 exit 1

:: Build!
nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1