@echo off
echo.
echo Dauerping auf %1 ...
echo.
echo ----------------------------------------------------------------- >> %1.txt
date /T >> %1.txt


:loop
time /T  >> %1.txt
ping %1 -n 60  >> %1.txt
find "Maximum" %1.txt
time /T
goto loop