@echo off
echo Starting LawPoint Backend and Frontend...
echo.
echo Backend will run on http://localhost:4000
echo Frontend will run on http://localhost:3000
echo.
echo Press Ctrl+C to stop the servers
echo.

start "LawPoint Backend" cmd /k "cd /d %~dp0backend && node server.js"
timeout /t 3 /nobreak >nul
start "LawPoint Frontend" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo Servers started in separate windows!
echo.
pause
