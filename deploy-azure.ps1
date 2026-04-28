# ============================================================
# deploy-azure.ps1 — Despliegue en Azure App Service
# Práctica 3 — Despliegue de Software
# ============================================================

param(
    [string]$ResourceGroup = "rg-practica3",
    [string]$AppServicePlan = "plan-practica3",
    [string]$AppName = "appinventario-practica3",   # <-- Debe ser único globalmente
    [string]$Location = "eastus",
    [string]$AppPath = "$PSScriptRoot\app"
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " Despliegue Azure App Service — Práctica 3" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

# ---- Verificar Azure CLI ----
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI no está instalada. Descárgala en: https://aka.ms/installazurecliwindows"
    exit 1
}

# ---- 1. Login en Azure ----
Write-Host "[1/7] Iniciando sesión en Azure..." -ForegroundColor Yellow
az login
if ($LASTEXITCODE -ne 0) { Write-Error "Login fallido"; exit 1 }

# ---- 2. Crear Resource Group ----
Write-Host "`n[2/7] Creando Resource Group '$ResourceGroup' en '$Location'..." -ForegroundColor Yellow
az group create --name $ResourceGroup --location $Location
Write-Host "  Resource Group creado." -ForegroundColor Green

# ---- 3. Crear App Service Plan (Free tier F1) ----
Write-Host "`n[3/7] Creando App Service Plan '$AppServicePlan' (Free F1)..." -ForegroundColor Yellow
az appservice plan create `
    --name $AppServicePlan `
    --resource-group $ResourceGroup `
    --sku F1 `
    --is-linux false
Write-Host "  App Service Plan creado." -ForegroundColor Green

# ---- 4. Crear Web App ----
Write-Host "`n[4/7] Creando Web App '$AppName'..." -ForegroundColor Yellow
az webapp create `
    --name $AppName `
    --resource-group $ResourceGroup `
    --plan $AppServicePlan
Write-Host "  Web App creada." -ForegroundColor Green

# ---- 5. Configurar Application Settings ----
Write-Host "`n[5/7] Configurando Application Settings..." -ForegroundColor Yellow
az webapp config appsettings set `
    --name $AppName `
    --resource-group $ResourceGroup `
    --settings `
        ASPNETCORE_ENVIRONMENT="Production" `
        APP_VERSION="1.0.0" `
        APP_NAME="AppInventario"
Write-Host "  Application Settings configurados." -ForegroundColor Green

# ---- 6. Habilitar HTTPS Only ----
Write-Host "`n[6/7] Habilitando HTTPS Only..." -ForegroundColor Yellow
az webapp update `
    --name $AppName `
    --resource-group $ResourceGroup `
    --https-only true
Write-Host "  HTTPS Only habilitado." -ForegroundColor Green

# ---- 7. Publicar la app (ZIP deploy) ----
Write-Host "`n[7/7] Publicando la aplicación..." -ForegroundColor Yellow

$zipPath = "$PSScriptRoot\app.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath }

Compress-Archive -Path "$AppPath\*" -DestinationPath $zipPath
Write-Host "  ZIP creado: $zipPath" -ForegroundColor Gray

az webapp deploy `
    --name $AppName `
    --resource-group $ResourceGroup `
    --src-path $zipPath `
    --type zip

Write-Host "`n================================================" -ForegroundColor Green
Write-Host " ¡Despliegue en Azure completado!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
$url = "https://$AppName.azurewebsites.net"
Write-Host " URL pública : $url" -ForegroundColor Cyan
Write-Host " Health      : $url/health/" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Green

# Abrir en navegador
Start-Process $url
