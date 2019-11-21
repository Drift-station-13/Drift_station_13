@echo off
set /p link="Enter github pull req link: "
java -jar ds-patch-pal.jar %link%
pause