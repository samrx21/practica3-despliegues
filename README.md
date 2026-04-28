# Práctica 3 — Publicación de Aplicaciones Web

**Despliegue de Software · 20%**  
Publicación de aplicaciones web en IIS (On-Premises) y Azure App Service.

---

## 👥 Integrantes

- Brayan Sanabria
- Nicolás Pérez
- Julián Clavijo
- María Isabel Tabares
- Samuel Metaute

---

## 🎥 Video de evidencia

> 📹 [Enlace al video narrado — pendiente de subir](#https://youtu.be/HljEBkYeBOM)

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
| Azure | `https://appinventario-practica3-apb3ghbcgdbxcffx.eastus-01.azurewebsites.net` |
| Azure Health | `https://appinventario-practica3-apb3ghbcgdbxcffx.eastus-01.azurewebsites.net/health/` |

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
└── README.md
```

