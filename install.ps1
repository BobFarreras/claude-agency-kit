<#
.SYNOPSIS
  Instal·la la configuracio d'aquest repositori a ~/.claude d'aquesta maquina.

.DESCRIPTION
  Posa la configuracio d'aquest kit a ~/.claude d'aquesta maquina.

  SOBREESCRIU els fitxers de ~/.claude que gestiona el repositori (CLAUDE.md,
  agents/, company/ i les skills que hi ha dins de skills/). Abans de tocar res
  en fa una copia de seguretat a ~/.claude/backups/install-<data>/.

  No toca mai settings.json, projects/, sessions/ ni cap altra cosa local.

.PARAMETER Apply
  Sense aquest parametre nomes ensenya que faria. Amb -Apply, ho fa.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -Apply
#>
[CmdletBinding()]
param(
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

$Repo       = $PSScriptRoot
$ClaudeHome = Join-Path $env:USERPROFILE '.claude'
$Managed    = @('CLAUDE.md', 'agents', 'company')   # skills es tracta a part

if (-not (Test-Path (Join-Path $Repo 'CLAUDE.md'))) {
  throw "Aixo no sembla el kit: no hi ha CLAUDE.md"
}

Write-Host "Repositori : $Repo"
Write-Host "Desti      : $ClaudeHome"
if (-not $Apply) { Write-Host "MODE PROVA - no es canviara res. Afegeix -Apply per fer-ho." -ForegroundColor Yellow }
Write-Host ""

# --- Que es copiara --------------------------------------------------------
$plan = @()
foreach ($m in $Managed) {
  $src = Join-Path $Repo $m
  if (Test-Path $src) {
    $n = if ((Get-Item $src).PSIsContainer) { @(Get-ChildItem $src -Recurse -File).Count } else { 1 }
    $plan += [pscustomobject]@{ Que = $m; Fitxers = $n }
  }
}
$repoSkills = @()
if (Test-Path (Join-Path $Repo 'skills')) {
  $repoSkills = Get-ChildItem (Join-Path $Repo 'skills') -Directory
  foreach ($s in $repoSkills) {
    $plan += [pscustomobject]@{ Que = "skills/$($s.Name)"; Fitxers = @(Get-ChildItem $s.FullName -Recurse -File).Count }
  }
}
$plan | Format-Table -AutoSize

if (-not $Apply) {
  Write-Host "Res fet. Torna-hi amb: .\install.ps1 -Apply" -ForegroundColor Yellow
  return
}

# --- Copia de seguretat del que es sobreescriura ---------------------------
$stamp  = Get-Date -Format 'yyyy-MM-dd-HHmm'
$backup = Join-Path $ClaudeHome "backups\install-$stamp"
New-Item -ItemType Directory -Path $backup -Force | Out-Null

function Backup-Item2 {
  param([string]$Path, [string]$Name)
  if (Test-Path $Path) {
    Copy-Item $Path (Join-Path $backup $Name) -Recurse -Force
    return $true
  }
  return $false
}

New-Item -ItemType Directory -Path $ClaudeHome -Force | Out-Null
$saved = 0

foreach ($m in $Managed) {
  $src = Join-Path $Repo $m
  if (-not (Test-Path $src)) { continue }
  $dst = Join-Path $ClaudeHome $m
  if (Backup-Item2 $dst $m) { $saved++ }
  if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
  Copy-Item $src $dst -Recurse -Force
  Write-Host "  instal·lat  $m"
}

foreach ($s in $repoSkills) {
  $dst = Join-Path $ClaudeHome "skills\$($s.Name)"
  if (Backup-Item2 $dst "skills-$($s.Name)") { $saved++ }
  if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
  New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
  Copy-Item $s.FullName $dst -Recurse -Force
  Write-Host "  instal·lat  skills/$($s.Name)"
}

Write-Host ""
Write-Host "Fet. Copia de seguretat del que hi havia abans ($saved elements): $backup" -ForegroundColor Green

# --- Que li falta a aquesta maquina ---------------------------------------
Write-Host ""
Write-Host "Comprovant l'entorn d'aquesta maquina..." -ForegroundColor Cyan

function Test-Cmd { param([string]$n) [bool](Get-Command $n -ErrorAction SilentlyContinue) }

$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$checks = @(
  [pscustomobject]@{ Cal = 'node';          Trobat = (Test-Cmd 'node');   Per = 'Hyperframes (motion graphics i render)' }
  [pscustomobject]@{ Cal = 'ffmpeg';        Trobat = (Test-Cmd 'ffmpeg'); Per = 'tall, audio i efectes' }
  [pscustomobject]@{ Cal = 'python';        Trobat = (Test-Cmd 'python'); Per = 'scripts del motor de reels' }
  [pscustomobject]@{ Cal = 'git';           Trobat = (Test-Cmd 'git');    Per = 'aquest repositori' }
  [pscustomobject]@{ Cal = 'chrome';        Trobat = (Test-Path $chrome); Per = 'captures en fosc i PDF' }
  [pscustomobject]@{ Cal = 'GROQ_API_KEY';  Trobat = [bool]$env:GROQ_API_KEY; Per = 'transcripcio dels reels' }
)
$checks | Format-Table -AutoSize

$falten = @($checks | Where-Object { -not $_.Trobat })
if ($falten.Count -gt 0) {
  Write-Host "Falta el de dalt marcat com a False. Sense aixo, les skills de video no funcionen." -ForegroundColor Yellow
}

Write-Host ""
# --- Les dependencies de tercers, que no son aqui --------------------------
Write-Host ""
Write-Host "Dependencies de tercers (no son en aquest kit):" -ForegroundColor Cyan

$sk = Join-Path $ClaudeHome 'skills'
$tercers = @(
  [pscustomobject]@{ Cal = 'hyperframes';  Trobat = (Test-Path (Join-Path $sk 'hyperframes'));  Per = 'motion graphics i render' }
  [pscustomobject]@{ Cal = 'media-use';    Trobat = (Test-Path (Join-Path $sk 'media-use'));    Per = 'logos, imatges, veu i musica' }
  [pscustomobject]@{ Cal = 'forja-reel';   Trobat = (Test-Path (Join-Path $sk 'forja-reelssets\motor-scripts\cut.py')); Per = 'tall, subtitols, lint i QC: /reel i /video-ia criden els seus scripts' }
)
$tercers | Format-Table -AutoSize

if (@($tercers | Where-Object { -not $_.Trobat }).Count -gt 0) {
  Write-Host "Sense les marcades com a False, /reel i /video-ia NO funcionen." -ForegroundColor Yellow
  Write-Host "Es passen a ma: descomprimeix-les a $sk"
}

Write-Host ""
Write-Host "La GROQ_API_KEY es posa per la finestra de variables d'entorn de Windows," -ForegroundColor Cyan
Write-Host "mai pel terminal: tot el que passa pel terminal acaba en una captura."
