param(
  [string]$Remote = "root@homeassistant.local",
  [string]$RemotePath = "/homeassistant/www/custom-cards/power-todoist-card-dev/powertodoist-card.js",
  [string]$LocalFile = "powertodoist-card.js",
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
Write-Host "Deploy complete. Bump your Lovelace resource query string, for example ?v=dev5."
