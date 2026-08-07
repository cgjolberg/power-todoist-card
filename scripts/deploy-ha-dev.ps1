param(
  [string]$Remote = "root@homeassistant.local",
  [string]$RemotePath = "/homeassistant/www/custom-cards/power-todoist-card-dev/powertodoist-card.js",
  [string]$LocalFile = "powertodoist-card.js",
  [string]$ResourceId = "336e2c31342849a094561382ce170bcd",
  [switch]$NoBump,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$localFilePath = Join-Path $repoRoot $LocalFile

if (-not (Test-Path -LiteralPath $localFilePath)) {
  throw "Card file not found: $localFilePath"
}

$target = "${Remote}:${RemotePath}"
Write-Host "Deploying $LocalFile to $target"

if ($DryRun) {
  Write-Host "Dry run only. Skipping scp."
  exit 0
}

scp $localFilePath $target
if ($LASTEXITCODE -ne 0) {
  throw "scp failed with exit code $LASTEXITCODE"
}

if ($NoBump) {
  Write-Host "Deploy complete. (-NoBump set; bump the Lovelace resource query string yourself.)"
} else {
  if (-not $env:HA_TOKEN) { $env:HA_TOKEN = [Environment]::GetEnvironmentVariable('HA_TOKEN', 'User') }
  $env:HA_HOST = ($Remote -split '@')[-1]
  node (Join-Path $PSScriptRoot "bump-ha-resource.mjs") $ResourceId
  if ($LASTEXITCODE -ne 0) { throw "Resource bump failed with exit code $LASTEXITCODE" }
  Write-Host "Deploy complete. Lovelace resource bumped automatically."
}
