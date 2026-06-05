param(
  [string]$ManifestPath = ".\recovery-osint\wayback_no_home_200_unique.json",
  [string]$OutputRoot = ".\recovered",
  [int]$Limit = 0,
  [int]$RequestTimeoutSec = 60,
  [string[]]$AllowHosts = @(),
  [switch]$FlashOnly,
  [switch]$SkipHtml
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Get-SafePathSegment {
  param([string]$Value)
  $safe = $Value -replace '[\\/:*?"<>|]', '_'
  if ($safe.Length -gt 140) {
    return $safe.Substring(0, 140)
  }
  return $safe
}

function Get-OutputPath {
  param(
    [string]$Root,
    [string]$Timestamp,
    [string]$Original,
    [string]$MimeType,
    [string]$Digest
  )

  $uri = [Uri]$Original
  $safeHost = Get-SafePathSegment $uri.Host
  $path = $uri.AbsolutePath.TrimStart("/")
  if ([string]::IsNullOrWhiteSpace($path)) {
    $path = "index"
  }

  [string[]]$parts = @($path -split "/" | ForEach-Object { Get-SafePathSegment $_ })
  $leaf = $parts[-1]
  if ([string]::IsNullOrWhiteSpace([IO.Path]::GetExtension($leaf))) {
    $extension = switch -Regex ($MimeType) {
      "text/html" { ".html"; break }
      "text/css" { ".css"; break }
      "javascript" { ".js"; break }
      "image/gif" { ".gif"; break }
      "image/jpeg" { ".jpg"; break }
      "image/png" { ".png"; break }
      "x-shockwave-flash" { ".swf"; break }
      "application/pdf" { ".pdf"; break }
      "text/xml" { ".xml"; break }
      default { ".bin"; break }
    }
    $parts[-1] = "$leaf$extension"
  }

  if ($uri.Query) {
    $queryHash = [Math]::Abs($uri.Query.GetHashCode())
    $parts[-1] = "{0}__q{1}{2}" -f [IO.Path]::GetFileNameWithoutExtension($parts[-1]), $queryHash, [IO.Path]::GetExtension($parts[-1])
  }

  if ($parts.Count -gt 1) {
    $pathParts = $parts[0..($parts.Count - 2)]
  } else {
    $pathParts = @()
  }

  $dirParts = @($Root, $safeHost) + $pathParts
  $dir = Join-Path -Path $dirParts[0] -ChildPath (($dirParts | Select-Object -Skip 1) -join "\")
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $name = "{0}__{1}__{2}" -f $Timestamp, $Digest, $parts[-1]
  return Join-Path $dir $name
}

$rows = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$items = $rows | Select-Object -Skip 1 | ForEach-Object {
  [pscustomobject]@{
    Timestamp = $_[0]
    Original = $_[1]
    StatusCode = $_[2]
    MimeType = $_[3]
    Digest = $_[4]
  }
}

if ($FlashOnly) {
  $items = $items | Where-Object { $_.MimeType -match "shockwave|octet" -or $_.Original -match "\.swf(\?|$)" }
}
if ($AllowHosts.Count -gt 0) {
  $items = $items | Where-Object { $AllowHosts -contains ([Uri]$_.Original).Host }
}
if ($SkipHtml) {
  $items = $items | Where-Object { $_.MimeType -notmatch "text/html" }
}
if ($Limit -gt 0) {
  $items = $items | Select-Object -First $Limit
}

$logPath = Join-Path $OutputRoot "_download_log.csv"
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
if (!(Test-Path $logPath)) {
  "timestamp,original,mimetype,digest,status,outfile,bytes,error" | Set-Content $logPath
}

$count = 0
$ok = 0
$failed = 0
foreach ($item in $items) {
  $count++
  $outPath = Get-OutputPath -Root $OutputRoot -Timestamp $item.Timestamp -Original $item.Original -MimeType $item.MimeType -Digest $item.Digest
  if (Test-Path $outPath) {
    $bytes = (Get-Item $outPath).Length
    $ok++
    ('"{0}","{1}","{2}","{3}","exists","{4}",{5},""' -f $item.Timestamp, $item.Original.Replace('"','""'), $item.MimeType, $item.Digest, $outPath.Replace('"','""'), $bytes) | Add-Content $logPath
    continue
  }

  $archiveUrl = "https://web.archive.org/web/$($item.Timestamp)id_/$($item.Original)"
  try {
    Invoke-WebRequest -Uri $archiveUrl -TimeoutSec $RequestTimeoutSec -OutFile $outPath
    $bytes = (Get-Item $outPath).Length
    $ok++
    ('"{0}","{1}","{2}","{3}","downloaded","{4}",{5},""' -f $item.Timestamp, $item.Original.Replace('"','""'), $item.MimeType, $item.Digest, $outPath.Replace('"','""'), $bytes) | Add-Content $logPath
  } catch {
    $failed++
    $message = $_.Exception.Message.Replace('"','""')
    ('"{0}","{1}","{2}","{3}","failed","{4}",0,"{5}"' -f $item.Timestamp, $item.Original.Replace('"','""'), $item.MimeType, $item.Digest, $outPath.Replace('"','""'), $message) | Add-Content $logPath
  }

  if (($count % 50) -eq 0) {
    Write-Host "Processed $count / $($items.Count); ok=$ok failed=$failed"
  }
}

Write-Host "Done. processed=$count ok=$ok failed=$failed log=$logPath"
