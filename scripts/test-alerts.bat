@echo off
echo ========================================
echo CREDIYA - HU10 Sistema de Alertas
echo Probando Alertas Automatizadas
echo ========================================

echo.
echo [1/5] Verificando que AlertManager esté funcionando...
curl -s http://localhost:9093 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ AlertManager: FUNCIONANDO
) else (
    echo ❌ AlertManager: NO DISPONIBLE
    echo Ejecuta primero: .\scripts\deploy-monitoring-only.bat
    exit /b 1
)

echo.
echo [2/5] Verificando que Prometheus esté funcionando...
curl -s http://localhost:9090 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Prometheus: FUNCIONANDO
) else (
    echo ❌ Prometheus: NO DISPONIBLE
    exit /b 1
)

echo.
echo [3/5] Verificando que MailHog esté funcionando...
curl -s http://localhost:8025 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ MailHog: FUNCIONANDO
) else (
    echo ❌ MailHog: NO DISPONIBLE
    echo Verifica que el servicio de email esté corriendo
)

echo.
echo ========================================
echo SIMULANDO ALERTAS PARA PRUEBAS
echo ========================================

echo.
echo [4/5] SIMULACIÓN 1: Deteniendo Authentication Service...
echo ⚠️  Esto generará una ALERTA CRÍTICA en 30 segundos
podman stop crediya-auth-service 2>nul
if %ERRORLEVEL% equ 0 (
    echo ✅ Authentication Service DETENIDO
    echo 📧 Espera 30-60 segundos para recibir email de alerta crítica
) else (
    echo ❌ No se pudo detener el servicio (puede que no esté corriendo)
)

echo.
echo Esperando 45 segundos para que se genere la alerta...
timeout /t 45 /nobreak > nul

echo.
echo [5/5] Verificando alertas en Prometheus...
echo 🔍 Abre estas URLs para ver las alertas:
echo.
echo 📊 Prometheus Alerts: http://localhost:9090/alerts
echo 🚨 AlertManager: http://localhost:9093
echo 📧 MailHog (emails): http://localhost:8025
echo.

echo ========================================
echo RESTAURANDO SERVICIOS
echo ========================================

echo.
echo Reiniciando Authentication Service...
podman start crediya-auth-service 2>nul
if %ERRORLEVEL% equ 0 (
    echo ✅ Authentication Service RESTAURADO
    echo 📧 Deberías recibir email de resolución en unos minutos
) else (
    echo ❌ No se pudo reiniciar el servicio
)

echo.
echo ========================================
echo PRUEBA DE ALERTAS COMPLETADA
echo ========================================
echo.
echo 📋 CHECKLIST DE VERIFICACIÓN:
echo.
echo 1. ✅ Ve a http://localhost:9090/alerts
echo    - Deberías ver "AuthenticationServiceDown" como FIRING
echo.
echo 2. ✅ Ve a http://localhost:9093
echo    - Deberías ver la alerta activa en AlertManager
echo.
echo 3. ✅ Ve a http://localhost:8025
echo    - Deberías ver emails de alerta crítica
echo.
echo 4. ✅ Espera 2-3 minutos y verifica que la alerta se resuelva
echo    - Cuando el servicio vuelva, la alerta debe desaparecer
echo.
echo ========================================
echo TIPOS DE ALERTAS CONFIGURADAS:
echo ========================================
echo.
echo 🚨 CRÍTICAS (30s):
echo   - AuthenticationServiceDown
echo   - SolicitudesServiceDown  
echo   - ReportesServiceDown
echo   - LoadBalancerDown
echo   - DatabaseDown
echo   - LocalStackDown
echo   - PrometheusDown
echo.
echo ⚠️  WARNING (2-5min):
echo   - HighCPUUsage (>80%)
echo   - HighMemoryUsage (>85%)
echo   - HighDiskUsage (>85%)
echo   - HighErrorRate (>5%)
echo   - SlowResponseTime (>2s)
echo   - TooManyRequests (>1000/min)
echo.
echo 📊 NEGOCIO (30min-2h):
echo   - NoNewLoans
echo   - HighRejectionRate (>80%)
echo.
echo ========================================
echo Para probar más alertas, puedes:
echo ========================================
echo.
echo # Simular alta CPU (si tienes stress tool):
echo stress --cpu 4 --timeout 300s
echo.
echo # Detener otros servicios:
echo podman stop crediya-solicitudes-service
echo podman stop crediya-reportes-service
echo podman stop crediya-nginx-lb-hu10
echo.
echo # Ver logs de AlertManager:
echo podman logs crediya-alertmanager-hu10
echo.
echo ========================================
