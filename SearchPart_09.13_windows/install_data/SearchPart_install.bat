@ECHO OFF

echo ---------Installing SearchPart---------


echo ---------Create SearchPart---------
set a=%cd%\SearchPart_09.13\SearchPart_start.exe
set b=%HOMEDRIVE%%HOMEPATH%\Desktop\SearchPart_start.lnk
cscript createLink.vbs "%b%" "%a%" "%cd%"

echo ---------Installing tesseract---------
start "tesseract installation" tesseract-ocr-setup-3.02.02.exe



echo ---------Checking Java-version ---------
java -version 2> tmp_java_version.txt

set /p JAVA_VERSION= < tmp_java_version.txt
echo %JAVA_VERSION%
del tmp_java_version.txt
set javastr=%JAVA_VERSION:~0,4%
set var=java

echo %var%
echo %javastr%

if NOT "%javastr%" equ "%var%" (goto javainstall) else (exit)

:javainstall
echo ---------Installing Java---------

if defined ProgramFiles(x86) (
	start "Java runtime installation" jre-7u45-windows-x64.exe
) else (
	start "Java runtime installation" jre-7u40-windows-i586.exe
)

:false
exit


