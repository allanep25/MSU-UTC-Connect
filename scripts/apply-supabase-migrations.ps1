# Run pending Supabase migrations from your PC (needs database password once)
# 1. Supabase Dashboard → Project Settings → Database → Connection string → URI
# 2. Replace [YOUR-PASSWORD] with your database password
# 3. In PowerShell: .\scripts\apply-supabase-migrations.ps1

param(
    [string]$ConnectionUri
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$sqlFile = Join-Path $repoRoot 'supabase\run-pending-migrations.sql'

if (-not (Test-Path $sqlFile)) {
    Write-Error "Missing $sqlFile"
}

if (-not $ConnectionUri) {
    Write-Host ''
    Write-Host 'MSU-UTC Connect — apply Supabase migrations'
    Write-Host 'Get URI: supabase.com → your project → Settings → Database → Connection string → URI'
    Write-Host 'Example host: db.ouwuhzttjnvdivsfbefe.supabase.co'
    Write-Host ''
    $ConnectionUri = Read-Host 'Paste full PostgreSQL URI (hidden input not supported — paste in window)'
}

$psql = Get-Command psql -ErrorAction SilentlyContinue
if (-not $psql) {
    Write-Host ''
    Write-Host 'psql is not installed. Use the manual option instead:'
    Write-Host "  Open $sqlFile"
    Write-Host '  Copy all → Supabase SQL Editor → Run'
    Write-Host ''
    exit 1
}

Write-Host 'Running migrations...'
& $psql.Source $ConnectionUri -f $sqlFile
if ($LASTEXITCODE -eq 0) {
    Write-Host 'Done. Designation and message recipient columns are ready.'
} else {
    Write-Host 'Failed. Check password/URI or run SQL manually in the dashboard.'
    exit $LASTEXITCODE
}
