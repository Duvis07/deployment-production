@echo off
echo ========================================
echo CREDIYA - HU10 PRUEBAS COMPLETAS
echo Sistema de Monitoreo y Alertas
echo ========================================

echo.
echo [1/8] Verificando servicios activos...
podman ps | findstr hu10

echo.
echo [2/8] Probando URLs principales...
echo Prometheus: http://localhost:9090
echo Grafana: http://localhost:3000
echo AlertManager: http://localhost:9093
echo Load Balancer: http://localhost:8888
echo MailHog: http://localhost:8025

echo.
echo [3/8] Probando Load Balancer endpoints...
curl -s http://localhost:8888/health/auth
curl -s http://localhost:8888/health/solicitudes
curl -s http://localhost:8888/health/reportes

echo.
echo [4/8] Generando alerta de prueba...
echo Deteniendo Node Exporter para generar alerta...
podman stop crediya-node-exporter-hu10

echo.
echo [5/8] Esperando 60 segundos para que se genere la alerta...
timeout /t 60 /nobreak

echo.
echo [6/8] Verificando alerta en AlertManager...
echo Revisa: http://localhost:9093
echo Revisa emails en: http://localhost:8025

echo.
echo [7/8] Restaurando servicio...
podman start crediya-node-exporter-hu10

echo.
echo [8/8] Pruebas completadas!
echo ========================================
echo URLS PARA VERIFICAR:
echo - Prometheus: http://localhost:9090/alerts
echo - AlertManager: http://localhost:9093
echo - Grafana: http://localhost:3000
echo - MailHog: http://localhost:8025
echo - Load Balancer: http://localhost:8888
echo ========================================

pause
