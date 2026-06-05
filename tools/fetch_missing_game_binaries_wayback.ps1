$ErrorActionPreference = "Stop"

$workspaceRoot = "c:\Users\Mark\Coding Projects\millsberry.com"
$destRoot = Join-Path $workspaceRoot "app\recovered-games\discovered"
New-Item -ItemType Directory -Force -Path $destRoot | Out-Null

$targets = @(
  @{ id = 220; times = @("20041229071023", "20041229201140", "20041229071355") },
  @{ id = 486; times = @("20070701195609", "20070703044735", "20080505144409") },
  @{ id = 505; times = @("20081211191239", "20090522093052") },
  @{ id = 515; times = @("20091012074953", "20091013181854") },
  @{ id = 520; times = @("20100207085200", "20100209010409") },
  @{ id = 525; times = @("20100528160737", "20100910090348") },
  @{ id = 535; times = @("20101005225241") }
)

$gvHostCandidates = @(
  "graphics.millsberry.com",
  "devgraphics.millsberry.com",
  "dev2graphics.millsberry.com",
  "www.millsberry.com",
  "millsberry.com"
)

function Get-GvPathCandidates([int]$id) {
  $paths = New-Object System.Collections.Generic.List[string]
  foreach ($version in 1..30) {
    $paths.Add("/g$id`_v$version.swf")
    $paths.Add("/flashgames/g$id`_v$version.swf")
    $paths.Add("/gamingsystem/g$id`_v$version.swf")
    $paths.Add("/images/g$id`_v$version.swf")
    $paths.Add("/images/gamingsystem/g$id`_v$version.swf")
  }
  return $paths | Select-Object -Unique
}

function Get-InteriorPathCandidates([int]$id) {
  return @(
    "/game_interiors/interior_$id`_v1.swf",
    "/game_interiors/interior_$id`_v2.swf",
    "/game_interiors/interior_$id`_v3.swf",
    "/game_interiors/interior_$id`_v4.swf",
    "/game_interiors/interior_$id`_v5.swf",
    "/game_interiors/interior_$id`_v6.swf",
    "/images/game_interiors/interior_$id`_v1.swf",
    "/images/game_interiors/interior_$id`_v2.swf",
    "/images/game_interiors/interior_$id`_v3.swf",
    "/images/game_interiors/interior_$id`_v4.swf",
    "/images/game_interiors/interior_$id`_v5.swf",
    "/images/game_interiors/interior_$id`_v6.swf"
  )
}

$requests = New-Object System.Collections.Generic.List[object]
foreach ($target in $targets) {
  $id = [int]$target.id
  $paths = (Get-GvPathCandidates -id $id) + (Get-InteriorPathCandidates -id $id)
  foreach ($timestamp in $target.times) {
    foreach ($targetHost in $gvHostCandidates) {
      foreach ($path in $paths) {
        $original = "http://$targetHost$path"
        $wayback = "https://web.archive.org/web/${timestamp}if_/$original"
        $requests.Add([pscustomobject]@{
          id = $id
          timestamp = $timestamp
          host = $targetHost
          path = $path
          original = $original
          wayback = $wayback
        })
      }
    }
  }
}

$seenNames = New-Object System.Collections.Generic.HashSet[string]
$downloaded = New-Object System.Collections.Generic.List[object]

foreach ($request in $requests) {
  $leaf = [System.IO.Path]::GetFileName($request.path)
  if (-not $leaf.ToLowerInvariant().EndsWith(".swf")) { continue }

  $outputName = if ($leaf -match '^g\d+_v\d+\.swf$') {
    $leaf
  } elseif ($leaf -match '^interior_\d+_v\d+\.swf$') {
    $leaf
  } else {
    "id$($request.id)_$leaf"
  }

  $outPath = Join-Path $destRoot $outputName
  if ($seenNames.Contains($outputName) -or (Test-Path $outPath)) { continue }

  try {
    $resp = Invoke-WebRequest -Uri $request.wayback -Method Head -TimeoutSec 45 -ErrorAction Stop
  } catch {
    continue
  }

  $contentType = String($resp.Headers["Content-Type"])
  if ($contentType -notmatch "shockwave-flash|application/octet-stream") {
    continue
  }

  try {
    Invoke-WebRequest -Uri $request.wayback -OutFile $outPath -TimeoutSec 120 -ErrorAction Stop
    if ((Get-Item $outPath).Length -lt 1024) {
      Remove-Item $outPath -Force
      continue
    }
    [void]$seenNames.Add($outputName)
    $downloaded.Add([pscustomobject]@{
      id = $request.id
      file = $outputName
      source = $request.wayback
      original = $request.original
      size = (Get-Item $outPath).Length
    })
  } catch {
    if (Test-Path $outPath) { Remove-Item $outPath -Force }
  }
}

$reportPath = Join-Path $workspaceRoot "recovery-osint\wayback_missing_game_fetch_report.json"
[pscustomobject]@{
  generated_at = (Get-Date).ToString("s")
  attempted = $requests.Count
  downloaded_count = $downloaded.Count
  downloaded = $downloaded
} | ConvertTo-Json -Depth 6 | Set-Content -Path $reportPath -Encoding UTF8

"WAYBACK_ATTEMPTED`t$($requests.Count)"
"WAYBACK_DOWNLOADED`t$($downloaded.Count)"
"REPORT`t$reportPath"
if ($downloaded.Count -gt 0) {
  $downloaded | Sort-Object id, file | ForEach-Object { "RECOVERED`t$($_.id)`t$($_.file)`t$($_.size)" }
}
