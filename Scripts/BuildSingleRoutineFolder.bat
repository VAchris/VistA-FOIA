REM change arguments as needed for your setup
REM
REM for /R c:\source %%f in (*.xml) do copy %%f x:\destination\
REM
REM if running the command from dos, remove the extra percent sign

for /R "C:\github\VistA-FOIA\Packages\" %%f in (*.m) do copy /Y "%%f" "c:\github\VistA-FOIA\Routines\"