@echo off
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0passwdgen.ps1" -Count 10 -CopyLast -OutputFile "%~dp0generated-password.txt"
