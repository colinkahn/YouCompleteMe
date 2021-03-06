git submodule update --init --recursive
:: Batch script will not exit if a command returns an error, so we manually do
:: it for commands that may fail.
if %errorlevel% neq 0 exit /b %errorlevel%

::
:: Python configuration
::

if %arch% == 32 (
  set python_path=C:\Python%python%
) else (
  set python_path=C:\Python%python%-x64
)

set PATH=%python_path%;%python_path%\Scripts;%PATH%
python --version

:: When using Python 3 on AppVeyor, CMake will always pick the 64 bit
:: libraries. We specifically tell CMake the right path to the libraries
:: according to the architecture.
if %python% == 35 (
  set EXTRA_CMAKE_ARGS="-DPYTHON_LIBRARY=%python_path%\libs\python%python%.lib"
)

appveyor DownloadFile https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install -r python\test_requirements.txt
if %errorlevel% neq 0 exit /b %errorlevel%
