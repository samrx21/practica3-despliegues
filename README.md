# Práctica 3 — Publicación de Aplicaciones Web

**Despliegue de Software · 20%**  
Publicación de aplicaciones web en IIS (On-Premises) y Azure App Service.

---

## 👥 Integrantes

| Nombre completo | Rol |
|---|---|
| _(Agregar nombre completo)_ | Desarrollador |
| _(Agregar nombre completo)_ | Desarrollador |

---

## 🎥 Video de evidencia

> 📹 [Enlace al video narrado — pendiente de subir](#)

---

## 📅 Fechas de publicación

| Despliegue | Fecha |
|---|---|
| IIS (On-Premises) | 27 de abril de 2026 |
| Azure App Service | 27 de abril de 2026 |

---

## 🌐 URLs

| Entorno | URL |
|---|---|
| IIS Local | `http://localhost:8080` |
| IIS Health | `http://localhost:8080/health/` |
| Azure | `https://appinventario-practica3.azurewebsites.net` |
| Azure Health | `https://appinventario-practica3.azurewebsites.net/health/` |

---

## 🏗️ Estructura del proyecto

```
practica3-despliegues/
├── app/                    # Aplicación web (HTML/CSS/JS)
│   ├── index.html          # Página principal
│   ├── style.css
│   ├── app.js
│   └── health/
│       └── index.html      # Endpoint /health → responde "OK"
├── evidencias/
│   ├── parte1-iis/         # Capturas de IIS
│   └── parte2-azure/       # Capturas de Azure
├── setup-iis.ps1           # Script de configuración IIS (requiere admin)
├── deploy-azure.ps1        # Script de despliegue en Azure
└── README.md
```

---

## 🚀 Instrucciones de despliegue

### Parte 1 — IIS (On-Premises)

```powershell
# Ejecutar como Administrador en PowerShell
cd C:\Users\samum\Desktop\practica3-despliegues
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup-iis.ps1
```

El script:
1. Habilita el rol IIS en Windows
2. Crea el App Pool `AppInventarioPool` (sin código administrado)
3. Crea el sitio `AppInventario` en el puerto 8080
4. Configura `index.html` como documento predeterminado

### Parte 2 — Azure App Service

> ⚠️ Requiere Azure CLI instalada: https://aka.ms/installazurecliwindows

```powershell
cd C:\Users\samum\Desktop\practica3-despliegues
.\deploy-azure.ps1
```

El script:
1. Hace `az login` (abre navegador)
2. Crea Resource Group `rg-practica3`
3. Crea App Service Plan F1 (gratis)
4. Crea Web App `appinventario-practica3`
5. Configura App Settings: `ASPNETCORE_ENVIRONMENT=Production`
6. Habilita HTTPS Only
7. Publica via ZIP deploy

---

## 📁 Evidencias

Ver carpeta [`/evidencias`](./evidencias/)

| # | Evidencia | Archivo |
|---|---|---|
| 1 | Creación del App Pool en IIS | `evidencias/parte1-iis/01-app-pool.png` |
| 2 | Configuración del sitio IIS | `evidencias/parte1-iis/02-sitio-iis.png` |
| 3 | App funcionando en localhost:8080 | `evidencias/parte1-iis/03-app-localhost.png` |
| 4 | Endpoint /health en IIS | `evidencias/parte1-iis/04-health-iis.png` |
| 5 | App Settings en Azure | `evidencias/parte2-azure/05-app-settings.png` |
| 6 | HTTPS Only habilitado | `evidencias/parte2-azure/06-https-only.png` |
| 7 | App en URL pública Azure | `evidencias/parte2-azure/07-app-azure.png` |
| 8 | Endpoint /health en Azure | `evidencias/parte2-azure/08-health-azure.png` |
