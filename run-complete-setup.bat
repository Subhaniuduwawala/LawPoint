@echo off
echo ============================================
echo   Starting WSL for LawPoint Setup
echo ============================================
echo.
echo This will:
echo   1. Build Docker images
echo   2. Test locally
echo   3. Push to Docker Hub (optional)
echo   4. Push to GitHub (optional)
echo.
echo Make sure you have:
echo   - Docker installed in WSL
echo   - GitHub repository created
echo   - Docker Hub account ready
echo.
pause
echo.
echo Opening WSL...
wsl bash -c "cd /mnt/c/Users/Asus/Documents/Project/LawPoint && chmod +x complete-setup.sh && ./complete-setup.sh"
pause
