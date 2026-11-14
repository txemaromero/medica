# Los mismos pasos que la comprobación automática de GitHub
# (.github/workflows/comprobacion.yml), para ejecutarlos antes de subir un
# cambio:
#   powershell -ExecutionPolicy Bypass -File tool/comprobar.ps1
# Con -Release también compila el App Bundle de release.
param([switch]$Release)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

function Paso([string]$nombre, [scriptblock]$orden) {
    Write-Host "== $nombre" -ForegroundColor Cyan
    & $orden
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Ha fallado: $nombre" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

Paso 'Dependencias' { flutter pub get --enforce-lockfile }
Paso 'Textos generados (lib/l10n)' { flutter gen-l10n }
Paso 'Formato' {
    dart format --output=none --set-exit-if-changed lib test integration_test tool
}
Paso 'Análisis estático' { flutter analyze }
Paso 'Tests unitarios y de widgets' { flutter test }
Paso 'APK de depuración' { flutter build apk --debug }
if ($Release) {
    # apkanalyzer (lo usa Flutter al comprobar el App Bundle) rechaza algunas
    # versiones del JDK 17 aunque sean válidas.
    $env:SKIP_JDK_VERSION_CHECK = '1'
    Paso 'App Bundle de release' { flutter build appbundle --release }
}
Write-Host 'Todo correcto.' -ForegroundColor Green
