@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem Get original density and size
for /f "tokens=3" %%a in ('"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm density') do set original_density=%%a
for /f "tokens=3" %%a in ('"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm size') do set original_size=%%a

rem Set temporary density and size
"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm density 200
"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm size 768x1360

rem Launch scrcpy
"C:\Program Files\scrcpy-win64-v3.3.1\scrcpy.exe" --keyboard=uhid --shortcut-mod=lalt %*

rem Restore original values
"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm density !original_density!
"C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm size !original_size!

endlocal
rem @echo off

rem "C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm density 200
rem "C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm size 768x1360

rem "C:\Program Files\scrcpy-win64-v3.3.1\scrcpy.exe" --keyboard=uhid --shortcut-mod=lalt %*

rem "C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm density 400
rem "C:\Program Files\scrcpy-win64-v3.3.1\adb.exe" shell wm size reset
