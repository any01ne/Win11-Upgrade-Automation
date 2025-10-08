@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'powershell.exe' -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%USERPROFILE%\Desktop\scriptt.ps1\"' -Verb RunAs"
