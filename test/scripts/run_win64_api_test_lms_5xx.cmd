REM 
REM Run a basic sick_scan_xd api test on Windows 64 (standalone, no ROS required) with a test server emulating a basic LMS5xx device
REM 

rem set PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\Python36_64;%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\Python37_64;%PATH%
rem set PATH=c:\vcpkg\installed\x64-windows\bin;%PATH%
if not exist \tmp mkdir \tmp

REM 
REM Build and run minimalistic api usage examples (Python, C, C++)
REM 

pushd ..\..\examples\scripts
call .\build_run_api_examples_windows.cmd
popd

REM 
REM Start test server
REM 

pushd ..\..\build_win64
python --version
REM Default LMS 511 scandata testset
start "python ../test/emulator/test_server.py" cmd /k python ../test/emulator/test_server.py --scandata_file=../test/emulator/scandata/20210302_lms511.pcapng.scandata.txt --scandata_frequency=20.0 --tcp_port=2112
@timeout /t 3
popd

REM
REM Start image viewer (simple standalone pointcloud visualization)
REM

start "image_viewer" ..\..\demo\image_viewer_api_test.html

REM 
REM Run sick_generic_caller
REM 

pushd ..\..\build_win64
.\Debug\sick_scan_xd_api_test.exe ../launch/sick_lms_5xx.launch hostname:=127.0.0.1 sw_pll_only_publish:=False
popd

@pause
