@echo off
title SoldaSur IA Chatbot - Consola de Inicio
echo ===================================================
echo       Iniciando SoldaSur IA Chatbot
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

:: 2. Activar entorno virtual y levantar servidor
echo [*] Activando entorno virtual...
if exist venv (
    call venv\Scripts\activate
    
    echo [*] Verificando modelos de Hugging Face - se descargaran si no estan en cache...
    python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2'); SentenceTransformer('sentence-transformers/distiluse-base-multilingual-cased-v2')"
    echo.
    
    :: Monitorear el puerto 9000 en segundo plano y abrir el navegador en cuanto esté listo
    echo [*] Esperando a que el servidor web este listo en el puerto 9000 para abrir el navegador...
    start /b cmd /c "@echo off & for /l %%i in (1,1,30) do (netstat -ano | findstr :9000 | findstr LISTENING >nul && (start http://localhost:9000 & exit) || timeout /t 1 >nul)"
    
    echo [*] Levantando servidor FastAPI...
    python -m uvicorn app.main:app --port 9000 --reload
) else (
    echo [ERROR] No se encontro la carpeta del entorno virtual 'venv'.
    echo Por favor, crea el entorno virtual antes de ejecutar este archivo.
    echo.
    pause
)
