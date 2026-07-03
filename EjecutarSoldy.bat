@echo off
title SoldaSur IA Chatbot - Consola de Inicio
echo ===================================================
echo       Iniciando SoldaSur IA Chatbot 🤖
echo ===================================================
echo.

:: 1. Verificar e iniciar Ollama
echo [*] Verificando estado de Ollama...
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] Ollama ya se encuentra en ejecucion.
) else (
    echo [*] Ollama no esta corriendo. Iniciando servidor de Ollama...
    start "" ollama serve
    echo [*] Esperando 3 segundos a que Ollama se inicialice...
    timeout /t 3 /nobreak > nul
)
echo.

:: 2. Levantar el navegador en segundo plano con un pequeño retardo
echo [*] Programando apertura del navegador en http://localhost:9000...
start /b cmd /c "timeout /t 4 /nobreak > nul && start http://localhost:9000"

:: 3. Activar entorno virtual y levantar servidor
echo [*] Activando entorno virtual y levantando servidor FastAPI...
if exist venv (
    call venv\Scripts\activate
    python -m uvicorn app.main:app --port 9000 --reload
) else (
    echo [ERROR] No se encontro la carpeta del entorno virtual 'venv'.
    echo Por favor, crea el entorno virtual antes de ejecutar este archivo.
    echo.
    pause
)
