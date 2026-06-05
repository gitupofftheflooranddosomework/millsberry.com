$ErrorActionPreference = "Stop"

class RecoveredSwfNormalizer {
  static [string] GetOriginalName([string]$fileName) {
    $match = [regex]::Match($fileName, '^(\d{14})__([A-Z0-9]+)__(.+)$')
    if ($match.Success) {
      return $match.Groups[3].Value
    }
    return $fileName
  }

  static [string] StripQueryMarker([string]$name) {
    return [regex]::Replace($name, '__q\d+(?=\.[^.]+$)', '')
  }

  static [string] Normalize([string]$fileName) {
    $original = [RecoveredSwfNormalizer]::GetOriginalName($fileName)
    return [RecoveredSwfNormalizer]::StripQueryMarker($original)
  }
}

class GameBinaryClassifier {
  static [bool] IsGameLikeSwf([string]$normalizedName, [string]$fullPath) {
    $name = $normalizedName.ToLowerInvariant()
    $pathText = $fullPath.ToLowerInvariant().Replace('\\', '/')

    if ($name -match '^g\d+_v\d+\.swf$') { return $true }
    if ($name -match '^flash_loader_v\d+_\d+\.swf$') { return $true }
    if ($name -match '^interior_\d+_v\d+\.swf$') { return $true }
    if ($name -match '^game_.*\.swf$') { return $true }
    if ($name -match '^g\d+_v\d+_.*\.swf$') { return $true }

    if ($pathText -match '/game_interiors/' -or $pathText -match '/gamingsystem/' -or $pathText -match '/flashgames/') {
      return $true
    }

    return $false
  }
}

$workspaceRoot = "c:\Users\Mark\Coding Projects\millsberry.com"
$sourceRoots = @(
  "official-recovered-assets",
  "official-full-backup",
  "official-core-recovered",
  "official-recovered",
  "another-user-backup-attempt"
) | ForEach-Object { Join-Path $workspaceRoot $_ } | Where-Object { Test-Path $_ }

$destRoot = Join-Path $workspaceRoot "app\recovered-games\discovered"
New-Item -ItemType Directory -Force -Path $destRoot | Out-Null

$candidates = New-Object System.Collections.Generic.List[object]

foreach ($root in $sourceRoots) {
  Get-ChildItem -Path $root -Recurse -File -Filter *.swf | ForEach-Object {
    $normalized = [RecoveredSwfNormalizer]::Normalize($_.Name)
    if ([GameBinaryClassifier]::IsGameLikeSwf($normalized, $_.FullName)) {
      $candidates.Add([pscustomobject]@{
        SourcePath = $_.FullName
        SourceRoot = $root
        NormalizedName = $normalized
        LastWriteTime = $_.LastWriteTimeUtc
        Size = $_.Length
      })
    }
  }
}

$bestByName = @{}
foreach ($candidate in $candidates) {
  $key = $candidate.NormalizedName.ToLowerInvariant()
  if (-not $bestByName.ContainsKey($key)) {
    $bestByName[$key] = $candidate
    continue
  }

  $current = $bestByName[$key]
  if ($candidate.LastWriteTime -gt $current.LastWriteTime) {
    $bestByName[$key] = $candidate
  }
}

$copied = 0
$copiedRows = New-Object System.Collections.Generic.List[object]

foreach ($entry in $bestByName.Values | Sort-Object NormalizedName) {
  $destPath = Join-Path $destRoot $entry.NormalizedName
  Copy-Item -LiteralPath $entry.SourcePath -Destination $destPath -Force
  $copied += 1
  $copiedRows.Add([pscustomobject]@{
    normalized_name = $entry.NormalizedName
    size = $entry.Size
    source = $entry.SourcePath
    destination = $destPath
  })
}

$reportPath = Join-Path $workspaceRoot "recovery-osint\game_binary_recovery_report.json"
$report = [pscustomobject]@{
  generated_at = (Get-Date).ToString("s")
  source_roots = $sourceRoots
  candidate_count = $candidates.Count
  unique_recovered_count = $copied
  destination_root = $destRoot
  recovered = $copiedRows
}
$report | ConvertTo-Json -Depth 6 | Set-Content -Path $reportPath -Encoding UTF8

"RECOVERED_CANDIDATE_COUNT`t$($candidates.Count)"
"RECOVERED_UNIQUE_COUNT`t$copied"
"DESTINATION`t$destRoot"
"REPORT`t$reportPath"
