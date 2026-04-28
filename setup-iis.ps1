# ============================================================
# setup-iis.ps1 — Configuración IIS para Práctica 3
# EJECUTAR COMO ADMINISTRADOR
# ============================================================

param(
    [string]$AppPath = "$PSScriptRoot\app",
    [int]$Port = 8080,
    [string]$AppPoolName = "AppInventarioPool",
    [string]$SiteName = "AppInventario"
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " Configuración IIS — Práctica 3" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Verificar que se ejecuta como admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Este script DEBE ejecutarse como Administrador."
    exit 1
}

# ---- 1. Habilitar IIS ----
Write-Host "`n[1/5] Habilitando IIS..." -ForegroundColor Yellow

$features = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-ManagementConsole"
)

foreach ($f in $features) {
    $feat = Get-WindowsOptionalFeature -Online -FeatureName $f
    if ($feat.State -ne "Enabled") {
        Write-Host "  Habilitando $f..." -ForegroundColor Gray
        Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart | Out-Null
    } else {
        Write-Host "  $f ya está habilitado." -ForegroundColor Green
    }
}

Import-Module WebAdministration -ErrorAction Stop

# ---- 2. Crear App Pool ----
Write-Host "`n[2/5] Creando App Pool '$AppPoolName'..." -ForegroundColor Yellow

if (Test-Path "IIS:\AppPools\$AppPoolName") {
    Write-Host "  App Pool ya existe — eliminando para recrear." -ForegroundColor Gray
    Remove-WebAppPool -Name $AppPoolName
}

New-WebAppPool -Name $AppPoolName
Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name "managedRuntimeVersion" -Value ""
Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name "startMode" -Value "AlwaysRunning"
Write-Host "  App Pool '$AppPoolName' creado. Runtime: Sin código administrado." -ForegroundColor Green

# ---- 3. Liberar puerto si está en uso ----
Write-Host "`n[3/5] Verificando puerto $Port..." -ForegroundColor Yellow

$existing = Get-WebBinding | Where-Object { $_.bindingInformation -like "*:${Port}:*" }
if ($existing) {
    Write-Host "  Puerto $Port en uso — eliminando binding existente." -ForegroundColor Gray
    $existing | Remove-WebBinding
}

# Eliminar sitio si ya existe
if (Get-Website -Name $SiteName -ErrorAction SilentlyContinue) {
    Remove-Website -Name $SiteName
    Write-Host "  Sitio anterior eliminado." -ForegroundColor Gray
}

# ---- 4. Crear sitio IIS ----
Write-Host "`n[4/5] Creando sitio '$SiteName' en puerto $Port..." -ForegroundColor Yellow

if (-not (Test-Path $AppPath)) {
    Write-Error "La carpeta de la app no existe: $AppPath"
    exit 1
}

New-Website -Name $SiteName `
            -PhysicalPath $AppPath `
            -ApplicationPool $AppPoolName `
            -Port $Port `
            -Force

# ---- 5. Configurar documento predeterminado ----
Write-Host "`n[5/5] Configurando documento predeterminado..." -ForegroundColor Yellow

# Asegurar que index.html está primero en la lista
$defaultDoc = Get-WebConfigurationProperty `
    -pspath "IIS:\Sites\$SiteName" `
    -filter "system.webServer/defaultDocument/files" `
    -name Collection

$hasIndex = $defaultDoc | Where-Object { $_.value -eq "index.html" }
if (-not $hasIndex) {
    Add-WebConfigurationProperty `
        -pspath "IIS:\Sites\$SiteName" `
        -filter "system.webServer/defaultDocument/files" `
        -name "." `
        -value @{value="index.html"}
}

# Iniciar el sitio
Start-Website -Name $SiteName

Write-Host "`n================================================" -ForegroundColor Green
Write-Host " ¡Configuración completada exitosamente!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host " App Pool : $AppPoolName" -ForegroundColor Cyan
Write-Host " Sitio    : $SiteName" -ForegroundColor Cyan
Write-Host " URL      : http://localhost:$Port" -ForegroundColor Cyan
Write-Host " Health   : http://localhost:$Port/health/" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Abre el navegador en: http://localhost:$Port" -ForegroundColor White
