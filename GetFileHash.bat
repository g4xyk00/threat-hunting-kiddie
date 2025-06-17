:: GetFileHash
:: Last Update: 17-Jun-2025
:: Author: g4xyk00

echo off
cls
pushd %~dp0

echo GetFileHash
@echo:

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1 delims=\" %%a in ('hostname') do (set hostName=%%a)
set folder=%sysdate%_%hostName%_hashes
mkdir %folder%
cd %folder%

set oPath=path.txt
set oHash=hash.txt
set fileExtension=".exe .bat .dll .hta .vbs"

:: Collect File Path
echo [+] Collect File Path
dir "C:\" /s /b /a-d > path_full.txt

dir "C:\$Recycle.Bin" /s /b /a-d > path_recycle_bin.txt
type path_recycle_bin.txt | findstr %fileExtension% > path_recycle_bin_f.txt

dir "C:\Program Files" /s /b /a-d > path_program_files.txt
type path_program_files.txt | findstr %fileExtension% > path_program_files_f.txt

dir "C:\Program Files (x86)" /s /b /a-d > path_program_files_x86.txt
type path_program_files_x86.txt | findstr %fileExtension% > path_program_files_x86_f.txt

dir "C:\ProgramData" /s /b /a-d > path_program_data.txt
type path_program_data.txt | findstr %fileExtension% > path_program_data_f.txt

dir "C:\Users" /s /b /a-d > path_users.txt
type path_users.txt | findstr %fileExtension% > path_users_f.txt

dir "C:\Windows" /s /b /a-d > path_windows.txt
type path_windows.txt | findstr %fileExtension% > path_windows_f.txt

type path_full.txt | findstr /V /I /C:"$Recycle.Bin" /C:"Program Files" /C:"Program Files" /C:"Program Files (x86)" /C:"ProgramData" /C:"Users" /C:"Windows" > path_others.txt
type path_others.txt | findstr %fileExtension% > path_others_f.txt

:: Generate SHA256 Hashes for Files
echo [+] Generate SHA256 Hashes for 
echo     [*] $Recycle.Bin
for /f "delims=" %%P in ('type path_recycle_bin_f.txt') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_recycle_bin.txt
	)
)

echo     [*] Others
for /f "delims=" %%P in ('type path_others_f.txt') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_others.txt
	)
)

echo     [*] ProgramData
for /f "delims=" %%P in ('type path_program_data_f.txt') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_program_data.txt
	)
)

echo     [*] Program Files (x86)
for /f "delims=" %%P in ('type path_program_files_x86_f.txt') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_program_files_x86.txt
	)
)

echo     [*] Program Files
for /f "delims=" %%P in ('type path_program_files_f.txt') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_program_files.txt
	)
)

echo     [*] Users
for /f "delims=" %%P in ('type path_users.txt_f') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_users.txt
	)
)

echo     [*] Windows
for /f "delims=" %%P in ('type path_windows.txt_f') do (
    for /f "delims=" %%H in ('certutil -hashfile "%%P" SHA256 ^| findstr /n "^" ^| findstr "^2:"') do (
		echo %%P:%%H >> hash_windows.txt
	)
)

@echo:
@echo:
echo [+] Reports are generated at %~dp0%folder%
pause