@echo off
title GILADSA Secure Live Server
cd /d "%~dp0"
echo Starting GILADSA Secure Prototype Server...
python server.py --port 8080 --user admin --password giladsa2026
pause
