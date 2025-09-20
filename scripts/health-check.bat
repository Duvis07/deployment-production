@echo off
echo ========================================
echo CREDIYA - Production Health Check
echo ========================================

set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "NC=[0m"

echo.
echo Checking container status...
echo ----------------------------------------
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "label=com.docker.compose.project=deployment-production"

echo.
echo ----------------------------------------
echo Service Health Checks
echo ----------------------------------------

echo.
echo %YELLOW%[1/8] Nginx Load Balancer...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[2/8] Authentication Service (Replica 1)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8080/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[3/8] Authentication Service (Replica 2)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8180/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[4/8] Solicitudes Service (Replica 1)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8081/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[5/8] Solicitudes Service (Replica 2)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8181/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[6/8] Reportes Service (Replica 1)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8082/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[7/8] Reportes Service (Replica 2)...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8182/actuator/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%[8/8] LocalStack...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:4566/_localstack/health || echo %RED%FAILED%NC%

echo.
echo ----------------------------------------
echo Monitoring Services
echo ----------------------------------------

echo.
echo %YELLOW%Prometheus...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:9090/-/healthy || echo %RED%FAILED%NC%

echo.
echo %YELLOW%Grafana...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:3000/api/health || echo %RED%FAILED%NC%

echo.
echo %YELLOW%AlertManager...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:9093/-/healthy || echo %RED%FAILED%NC%

echo.
echo %YELLOW%MailHog...%NC%
curl -s -o nul -w "HTTP Status: %%{http_code} - Response Time: %%{time_total}s\n" http://localhost:8025 || echo %RED%FAILED%NC%

echo.
echo ========================================
echo Database Connections
echo ========================================

echo.
echo %YELLOW%PostgreSQL Auth...%NC%
podman exec crediya-postgres-auth-master pg_isready -U postgres -d crediya_authentication_db && echo %GREEN%HEALTHY%NC% || echo %RED%FAILED%NC%

echo.
echo %YELLOW%PostgreSQL Solicitudes...%NC%
podman exec crediya-postgres-solicitudes-master pg_isready -U postgres -d crediya_solicitudes_db && echo %GREEN%HEALTHY%NC% || echo %RED%FAILED%NC%

echo.
echo ========================================
echo Resource Usage
echo ========================================
podman stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" --filter "label=com.docker.compose.project=deployment-production"

echo.
echo ========================================
echo Health Check Complete!
echo ========================================
