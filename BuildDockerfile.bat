@echo off
powershell.exe -executionpolicy remotesigned -File "%~dp0%~n0.ps1" %*
