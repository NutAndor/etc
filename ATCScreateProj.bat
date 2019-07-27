@echo off
rem Created on 2019-04-13 by Nut

rem v-----------------Change these settings to your values!
set   AT_BASE=C:\AT\
set ATCS_BASE=C:\AT\ATCS\
set  ATCS_DIR=C:\AT\ATCS\%1\ATCS\%1\
set AT_SRCDIR=C:\AT\Zukero\andors-trail\AndorsTrail
set AT_TGTDIR=C:\AT\NutAndor\andors-trail\AndorsTrail
set AT_SRCGIT=https://github.com/Zukero/andors-trail.git
set AT_TGTGIT=https://github.com/NutAndor/andors-trail.git
set  ATCS_GIT=https://github.com/%1.git


echo.
echo.
echo Create the environment for the new ATCS project "%1"
echo (Press ctrl-C to abort)
pause

echo.
echo.
echo.
echo  Example: "NutAndor" wants to create a new project "brimhaven"
echo. " 
echo  " ATCS-Sources ------------------------------------------------+
echo  " for the new content                                          |
echo  " (cloned from git:brimhaven branch:master)                    |
echo  "                                                              |
echo  "                                                              |
echo  " AT-Source ------------------------------------------------+  |
echo  " Sources of the actual AT version                          |  |
echo  " (cloned from git:zukero branch:master)                    v  v
echo  "                                                           ATCS
echo  "                                                            |
echo  "  +-------- AT-Target <-------------------------------------+
echo  "  |         Sources for test AT version
echo  "  |         (cloned from git:NutAndor branch:brimhaven)
echo  "  |         (forked from git:zukero)
echo  "  v
echo  " Android_Studio
echo  "  |
echo  "  +-------> APK
echo. " 


if "%1" == "-?" goto help 
if "%1" == "" goto syntax_error
if not "%2" == "" goto syntax_error

echo  "
echo  " Android_Studio will always have the same project "NutAndor".
echo  " To switch between different project, you just use  git + ATCS:
echo  "  -> set branch in local repository "Nutandor:brimhaven"   and
echo  "  -> work with ATCS project "brimhaven"
echo  "
echo.
echo So we need 3 git projects cloned:
echo   1. The ATCS sources  (Git clone of the ATCS project)
echo        e.g.  %ATCS_GIT%   %AT_SRCDIR%:master
echo   2. The actual game sources  (Git clone of Zukero's AT version)
echo        e.g.  %AT_SRCGIT%   %AT_SRCDIR%:master
echo   3. The target game source for Android Studio compile  (Git clone of your forked AT version)
echo        e.g.  %AT_TGTGIT%   %AT_TGTDIR%:%1
echo.


if exist %ATCS_DIR% (
echo.
echo ERROR: %ATCS_DIR%  exists already!
goto ende
)


if not exist %AT_BASE%  md %AT_BASE%
if not exist %ATCS_BASE%  md %ATCS_BASE%
if not exist %ATCS_BASE%%1  md %ATCS_BASE%%1


if exist %AT_SRCDIR%  goto git1x
echo.
echo TODO: Clone source AT version  %AT_SRCGIT%  to  %AT_BASE%
echo.
pause
:git1x


if exist %AT_TGTDIR%  goto git2x
echo.
echo TODO: Clone target AT version  %AT_TGTGIT%  to  %AT_BASE%
echo.
pause
:git2x


echo.
echo TODO: Create new ATCS workspace and a new ATCS project
echo   Use as workspace: %ATCS_BASE%%1\ATCS
echo   Then create a new ATCS project "%1"
echo   with "%AT_SRCDIR%" as Source directory
echo Then quit ATCS again.
echo Important: Wait ATCS to be ready before you proceed!
echo.
pause
if not exist %ATCS_DIR%.project  (
echo ERROR: ATCS project "%1" not created!
goto ende
)

rem  Git and ATCS both want the target directory not to exist first.
rem  So we have to rename it temporarily
ren %ATCS_BASE%%1\ATCS ATCS_999

echo.
echo TODO: Clone ATCS version e.g.  "%ATCS_GIT%"
echo       to local path  "%ATCS_BASE%%1\ATCS\%1"
pause
if not exist %ATCS_DIR%.  (
echo.
echo ERROR: ATCS "%1" not cloned!
goto ende
)

del  %ATCS_BASE%%1\ATCS\.workspace > nul
copy %ATCS_BASE%%1\ATCS_999\.workspace  %ATCS_BASE%%1\ATCS\.workspace
del  %ATCS_BASE%%1\ATCS\%1\.project > nul
copy %ATCS_BASE%%1\ATCS_999\%1\.project %ATCS_BASE%%1\ATCS\%1\.project


echo.
echo DONE.

echo.
echo At last: What about the "drawable"?
echo. I prefer to have real directories than reference links.
echo  "   Enter:   Exchange the links to "drawable" by a real copy
echo  "   Ctrl-C:  Leave them alone
echo.
pause

del %ATCS_DIR%created\drawable
md %ATCS_DIR%created\drawable
copy %AT_SRCDIR%\res\drawable\*.* %ATCS_DIR%created\drawable\
del %ATCS_DIR%altered\drawable
md %ATCS_DIR%altered\drawable
copy %AT_SRCDIR%\res\drawable\*.* %ATCS_DIR%altered\drawable\

copy %ATCS_DIR%created\spritesheets\*.* %AT_TGTDIR%\res\drawable\
copy %ATCS_DIR%created\spritesheets\*.* %ATCS_DIR%created\drawable\
copy %ATCS_DIR%created\spritesheets\*.* %ATCS_DIR%altered\drawable\


rem create link to nutAndor


goto ende

:help
echo Help
goto ende

:syntax_error
echo This command helps creating the environment for a new ATCS project
echo Syntax:  %0  project_name

:ende
echo.
echo (End of script)
echo.
pause