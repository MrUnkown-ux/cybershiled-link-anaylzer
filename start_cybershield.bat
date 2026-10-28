@echo off
title CyberShield Launcher (No Docker Required)
echo ========================================================
echo    CyberShield: Safe Link Analyzer & Virtual Browser
echo               (Running 100%% Locally without Docker)
echo ========================================================
echo.

cd /d "%~dp0"

echo [1/2] Starting CyberShield Backend (FastAPI on Port 8000)...
start "CyberShield Backend (Port 8000)" cmd /k "cd backend && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

timeout /t 3 /nobreak >nul

echo [2/2] Starting CyberShield Frontend (Vite on Port 5173)...
start "CyberShield Frontend (Port 5173)" cmd /k "cd frontend && npm run dev"

timeout /t 3 /nobreak >nul

echo.
echo ========================================================
echo Both services are running!
echo Opening CyberShield Web Dashboard in your browser...
echo.
echo   - Web Dashboard: http://localhost:5173
echo   - API Documentation: http://localhost:8000/docs
echo ========================================================
start http://localhost:5173

pause
