@echo off
echo ========================================
echo CREDIYA - HU10 Testing Script
echo ========================================

echo.
echo [1/5] Testing Monitoring Services...
echo.

echo Testing Prometheus...
curl -s http://localhost:9090/-/healthy >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Prometheus: HEALTHY
) else (
    echo  Prometheus: FAILED
)

echo Testing Grafana...
curl -s http://localhost:3000 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Grafana: HEALTHY
) else (
    echo  Grafana: FAILED
)

echo Testing AlertManager...
curl -s http://localhost:9093 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  AlertManager: HEALTHY
) else (
    echo  AlertManager: FAILED
)

echo.
echo [2/5] Testing Load Balancer...
echo.

echo Testing Load Balancer...
curl -s http://localhost:8888 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Load Balancer: HEALTHY
) else (
    echo  Load Balancer: FAILED
)

echo.
echo [3/5] Testing Microservices through Load Balancer...
echo.

echo Testing Auth Service through LB...
curl -s http://localhost:8888/health/auth >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Auth Service (via LB): HEALTHY
) else (
    echo  Auth Service (via LB): FAILED
)

echo Testing Solicitudes Service through LB...
curl -s http://localhost:8888/health/solicitudes >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Solicitudes Service (via LB): HEALTHY
) else (
    echo  Solicitudes Service (via LB): FAILED
)

echo Testing Reportes Service through LB...
curl -s http://localhost:8888/health/reportes >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Reportes Service (via LB): HEALTHY
) else (
    echo  Reportes Service (via LB): FAILED
)

echo.
echo [4/5] Testing Direct Microservices...
echo.

echo Testing Auth Service directly...
curl -s http://localhost:8080/actuator/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Auth Service (direct): HEALTHY
) else (
    echo  Auth Service (direct): FAILED
)

echo Testing Solicitudes Service directly...
curl -s http://localhost:8081/actuator/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Solicitudes Service (direct): HEALTHY
) else (
    echo  Solicitudes Service (direct): FAILED
)

echo Testing Reportes Service directly...
curl -s http://localhost:8082/actuator/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Reportes Service (direct): HEALTHY
) else (
    echo  Reportes Service (direct): FAILED
)

echo.
echo [5/5] Testing Infrastructure Services...
echo.

echo Testing LocalStack...
curl -s http://localhost:4566/_localstack/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  LocalStack: HEALTHY
) else (
    echo  LocalStack: FAILED
)

echo Testing MailHog...
curl -s http://localhost:8025 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  MailHog: HEALTHY
) else (
    echo  MailHog: FAILED
)

echo.
echo ========================================
echo HU10 TESTING COMPLETE!
echo ========================================
echo.
echo  Access URLs:
echo - Grafana Dashboard: http://localhost:3000 (admin/admin123)
echo - Prometheus Metrics: http://localhost:9090
echo - AlertManager: http://localhost:9093
echo - Load Balancer: http://localhost:8888
echo - MailHog: http://localhost:8025
echo.
echo  Direct Service URLs:
echo - Auth Service: http://localhost:8080
echo - Solicitudes Service: http://localhost:8081
echo - Reportes Service: http://localhost:8082
echo - LocalStack: http://localhost:4566
echo.
echo ========================================
