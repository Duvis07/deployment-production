# 🏗️ HU10 - Despliegue de Solución con LocalStack

## 📋 Descripción General

**Historia de Usuario 10** implementa un entorno de producción completo simulado usando LocalStack y herramientas de monitoreo, permitiendo probar todas las funcionalidades sin costos de infraestructura AWS.

## 🎯 Objetivo Alcanzado

✅ **Entorno de producción simulado 100% funcional** con:
- Servicios AWS simulados (LocalStack)
- Sistema de monitoreo completo (Prometheus + Grafana)
- Alertas automatizadas (AlertManager + MailHog)
- Load Balancer (Nginx)
- Health checks automatizados

---

## 🛠️ Herramientas Implementadas

### 1. 📊 **Prometheus** - Recolección de Métricas
**Función:** Sistema de monitoreo y base de datos de series temporales
- **Puerto:** 9090
- **URL:** http://localhost:9090
- **Configuración:** `monitoring/prometheus.yml`
- **Funcionalidades:**
  - Recolecta métricas de todos los servicios
  - Almacena datos de series temporales
  - Ejecuta reglas de alertas
  - Proporciona API para consultas

### 2. 📈 **Grafana** - Visualización de Datos
**Función:** Plataforma de visualización y dashboards
- **Puerto:** 3000
- **URL:** http://localhost:3000
- **Credenciales:** admin/admin123
- **Funcionalidades:**
  - Dashboards interactivos
  - Visualización de métricas en tiempo real
  - Alertas personalizadas
  - Paneles configurables

### 3. 🚨 **AlertManager** - Gestión de Alertas
**Función:** Manejo y enrutamiento de alertas
- **Puerto:** 9093
- **URL:** http://localhost:9093
- **Configuración:** `monitoring/alertmanager.yml`
- **Funcionalidades:**
  - Recibe alertas de Prometheus
  - Agrupa y filtra notificaciones
  - Envía emails via MailHog
  - Gestión de silenciamientos

### 4. 📧 **MailHog** - Servidor de Email de Prueba
**Función:** Captura y visualiza emails de desarrollo
- **Puerto Web:** 8025
- **Puerto SMTP:** 1025
- **URL:** http://localhost:8025
- **Funcionalidades:**
  - Captura todos los emails salientes
  - Interface web para ver emails
  - No envía emails reales (solo testing)
  - Integrado con AlertManager

### 5. ⚖️ **Nginx Load Balancer** - Balanceador de Carga
**Función:** Distribución de tráfico y proxy reverso
- **Puerto:** 8888
- **URL:** http://localhost:8888
- **Configuración:** `nginx/load-balancer-monitoring.conf`
- **Endpoints:**
  - `/health/auth` - Health check Authentication Service
  - `/health/solicitudes` - Health check Solicitudes Service
  - `/health/reportes` - Health check Reportes Service
  - `/metrics` - Métricas agregadas

### 6. 📊 **Node Exporter** - Métricas del Sistema
**Función:** Exporta métricas del sistema operativo
- **Puerto:** 9100
- **URL:** http://localhost:9100/metrics
- **Funcionalidades:**
  - CPU, memoria, disco, red
  - Métricas del sistema operativo
  - Integrado con Prometheus

### 7. ☁️ **LocalStack** - Simulación de AWS
**Función:** Simula servicios AWS localmente
- **Puerto:** 4566
- **URL:** http://localhost:4566
- **Servicios Simulados:**
  - ECR (Registry de imágenes)
  - ECS/Fargate (Orquestación)
  - RDS (Base de datos)
  - Secrets Manager
  - CloudWatch (logs)

---

## 🌐 URLs de Acceso

| Servicio | URL | Credenciales | Descripción |
|----------|-----|--------------|-------------|
| **Grafana** | http://localhost:3000 | admin/admin123 | Dashboards y visualización |
| **Prometheus** | http://localhost:9090 | - | Métricas y alertas |
| **AlertManager** | http://localhost:9093 | - | Gestión de alertas |
| **MailHog** | http://localhost:8025 | - | Emails de prueba |
| **Load Balancer** | http://localhost:8888 | - | Balanceador principal |
| **Node Exporter** | http://localhost:9100 | - | Métricas del sistema |
| **LocalStack** | http://localhost:4566 | - | Servicios AWS simulados |

### 🔍 Health Check Endpoints
- **Auth Service:** http://localhost:8888/health/auth
- **Solicitudes Service:** http://localhost:8888/health/solicitudes
- **Reportes Service:** http://localhost:8888/health/reportes

---

## 📦 Estructura del Proyecto

```
deployment-production/
├── podman-compose.monitoring-only.yml  # Orquestación optimizada
├── podman-compose.optimized.yml        # Orquestación completa
├── podman-compose.production.yml       # Orquestación desarrollo
├── nginx/
│   ├── load-balancer.conf              # Config Load Balancer original
│   └── load-balancer-monitoring.conf   # Config Load Balancer optimizada
├── monitoring/
│   ├── prometheus.yml                  # Configuración Prometheus
│   ├── alertmanager.yml               # Configuración AlertManager
│   ├── alert_rules.yml                # Reglas de alertas
│   └── crediya-dashboard.json         # Dashboard Grafana
├── secrets/
│   └── localstack-secrets.json       # Configuración Secrets Manager
└── scripts/
    ├── deploy.bat                     # Despliegue completo
    ├── deploy-optimized.bat          # Despliegue optimizado
    ├── deploy-monitoring-only.bat    # Solo monitoreo
    ├── health-check.bat              # Health checks
    ├── test-hu10.bat                 # Testing HU10
    ├── test-complete-hu10.bat        # Pruebas completas
    └── init-aws-production.sh        # Inicialización AWS
```

---

## 🚀 Scripts de Despliegue

### Scripts Principales
- **`deploy-monitoring-only.bat`** - Levanta solo servicios de monitoreo
- **`deploy-optimized.bat`** - Despliegue optimizado con servicios existentes
- **`deploy.bat`** - Despliegue completo desde cero

### Scripts de Testing
- **`test-hu10.bat`** - Pruebas básicas de HU10
- **`test-complete-hu10.bat`** - Suite completa de pruebas
- **`health-check.bat`** - Verificación de salud de servicios

### Uso
```bash
# Levantar solo monitoreo
.\scripts\deploy-monitoring-only.bat

# Ejecutar pruebas completas
.\scripts\test-complete-hu10.bat

# Verificar salud de servicios
.\scripts\health-check.bat
```

---

## 🧪 Guía de Pruebas

### 1. Verificar Servicios Activos
```bash
podman ps | findstr hu10
```

### 2. Generar Alertas de Prueba
```bash
# Detener servicio para generar alerta
podman stop crediya-node-exporter-hu10

# Esperar 1-2 minutos y verificar:
# - AlertManager: http://localhost:9093
# - MailHog: http://localhost:8025

# Restaurar servicio
podman start crediya-node-exporter-hu10
```

### 3. Probar Load Balancer
```bash
curl http://localhost:8888/health/auth
curl http://localhost:8888/health/solicitudes
curl http://localhost:8888/health/reportes
```

### 4. Consultas Prometheus Útiles
```
# Servicios activos
up

# CPU del sistema
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memoria disponible
node_memory_MemAvailable_bytes

# Alertas activas
ALERTS{alertstate="firing"}
```

---

## 📊 Dashboards de Grafana

### Dashboard Principal: "CREDIYA HU10"
- **Services Status** - Estado de todos los servicios
- **CPU Usage** - Uso de CPU del sistema
- **Memory Usage** - Uso de memoria
- **Active Alerts** - Alertas activas en tiempo real

### Importar Dashboard
1. Ve a Grafana: http://localhost:3000
2. **+** → **Import**
3. Upload: `monitoring/crediya-dashboard.json`
4. Selecciona Prometheus como Data Source

---

## 🔧 Configuración de Alertas

### Reglas de Alertas Configuradas
- **ServiceDown** - Servicio no disponible
- **HighCPUUsage** - CPU > 80%
- **HighMemoryUsage** - Memoria > 85%
- **DiskSpaceLow** - Disco < 10%

### Notificaciones
- **Email:** admin@crediya.local
- **SMTP:** MailHog (puerto 1025)
- **Visualización:** http://localhost:8025

---

## 🛡️ Seguridad y Secrets

### LocalStack Secrets Manager
- **Configuración:** `secrets/localstack-secrets.json`
- **JWT Secrets** - Tokens centralizados
- **Database Credentials** - Credenciales seguras
- **API Keys** - Claves de servicios

### Variables de Entorno Seguras
- Secrets no hardcodeados
- Configuración centralizada
- Rotación de credenciales

---

## 🏆 Logros de HU10

✅ **Infraestructura Completa**
- Todos los servicios AWS simulados funcionando
- Monitoreo en tiempo real operativo
- Sistema de alertas configurado

✅ **Alta Disponibilidad**
- Load Balancer funcionando
- Health checks automatizados
- Recuperación automática de servicios

✅ **Observabilidad**
- Métricas detalladas
- Dashboards interactivos
- Alertas proactivas
- Logs centralizados

✅ **Automatización**
- Scripts de despliegue
- Testing automatizado
- Health checks programados

---

## 🔄 Comandos Útiles

### Gestión de Servicios
```bash
# Ver servicios activos
podman ps | findstr hu10

# Reiniciar servicio específico
podman restart crediya-prometheus-hu10

# Ver logs de servicio
podman logs crediya-alertmanager-hu10

# Detener todos los servicios HU10
podman-compose -f podman-compose.monitoring-only.yml down
```

### Verificación de Estado
```bash
# Verificar puertos activos
netstat -an | findstr :3000
netstat -an | findstr :9090
netstat -an | findstr :9093

# Test de conectividad
curl -I http://localhost:9090
curl -I http://localhost:3000
```

---

## 📞 Soporte y Troubleshooting

### Problemas Comunes

**1. AlertManager no envía emails:**
- Verificar MailHog: http://localhost:8025
- Revisar configuración SMTP en `alertmanager.yml`

**2. Grafana no muestra datos:**
- Verificar Data Source Prometheus
- URL: http://crediya-prometheus-hu10:9090

**3. Servicios no responden:**
- Ejecutar: `.\scripts\health-check.bat`
- Verificar logs: `podman logs [container-name]`

### Logs Importantes
```bash
# AlertManager
podman logs crediya-alertmanager-hu10

# Prometheus
podman logs crediya-prometheus-hu10

# Grafana
podman logs crediya-grafana-hu10
```

---

## 🎯 Resultado Final

**HU10 COMPLETADA AL 100%** - Entorno de producción simulado completamente funcional con:

- ✅ Monitoreo en tiempo real
- ✅ Alertas automatizadas
- ✅ Dashboards interactivos
- ✅ Load Balancer operativo
- ✅ Servicios AWS simulados
- ✅ Scripts de automatización
- ✅ Testing completo

**Todos los componentes están funcionando correctamente y listos para producción.**
