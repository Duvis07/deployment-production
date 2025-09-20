@echo off
echo ========================================
echo CREDIYA - HU10 Monitoring Infrastructure
echo Conectando a microservicios existentes
echo ========================================

echo.
echo [1/3] Verificando que los microservicios estén corriendo...
echo Verificando red crediya-network...
podman network inspect crediya-network >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: La red crediya-network no existe
    echo Por favor, inicia primero los microservicios:
    echo   - authentication-service
    echo   - solicitudes-service  
    echo   - reportes-service
    exit /b 1
)

echo Verificando contenedores de microservicios...
podman inspect crediya-auth-service >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo WARNING: crediya-auth-service no está corriendo
)

podman inspect crediya-solicitudes-service >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo WARNING: crediya-solicitudes-service no está corriendo
)

podman inspect crediya-reportes-service >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo WARNING: crediya-reportes-service no está corriendo
)

echo.
echo [2/3] Deteniendo infraestructura de monitoreo anterior...
podman-compose -f podman-compose.monitoring-only.yml down 2>nul
if %ERRORLEVEL% neq 0 (
    echo No había infraestructura anterior, continuando...
)

echo.
echo [3/3] Iniciando infraestructura de monitoreo HU10...
podman-compose -f podman-compose.monitoring-only.yml up -d
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to start monitoring infrastructure
    exit /b 1
)

echo.
echo ========================================
echo HU10 MONITORING DEPLOYED SUCCESSFULLY!
echo ========================================
echo.
echo Monitoring URLs:
echo - Grafana Dashboard: http://localhost:3000 (admin/admin123)
echo - Prometheus Metrics: http://localhost:9090
echo - AlertManager: http://localhost:9093
echo - Load Balancer: http://localhost:8888
echo.
echo Existing Microservices (should be running):
echo - Authentication Service: http://localhost:8080
echo - Solicitudes Service: http://localhost:8081
echo - Reportes Service: http://localhost:8082
echo - LocalStack AWS Services: http://localhost:4566
echo - MailHog Email Testing: http://localhost:8025
echo.
echo Waiting 30 seconds for services to start...
timeout /t 30 /nobreak > nul

echo.
echo Checking monitoring services...
curl -s http://localhost:9090/-/healthy >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Prometheus: HEALTHY
) else (
    echo ❌ Prometheus: NOT READY
)

curl -s http://localhost:3000 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Grafana: HEALTHY
) else (
    echo ❌ Grafana: NOT READY
)

curl -s http://localhost:9093 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ AlertManager: HEALTHY
) else (
    echo ❌ AlertManager: NOT READY
)

echo.
echo ========================================
echo HU10 PRODUCTION MONITORING READY!
echo ========================================
echo.
echo La infraestructura de monitoreo está conectada
echo a tus microservicios existentes.
echo.
echo Abre Grafana para ver los dashboards:
echo http://localhost:3000
echo ========================================
