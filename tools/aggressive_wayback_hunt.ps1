$ErrorActionPreference = "Stop"

class CdxClient {
  [string]$BaseUrl
  [int]$TimeoutSec

  CdxClient([string]$baseUrl, [int]$timeoutSec) {
    $this.BaseUrl = $baseUrl
    $this.TimeoutSec = $timeoutSec
  }

  [object[]] Query([string]$urlPattern, [int]$limit) {
    $query = @(
      "url=$([uri]::EscapeDataString($urlPattern))",
      "output=json",
      "fl=timestamp,original,statuscode,mimetype,digest",
      "filter=statuscode:200",
      "collapse=digest",
      "limit=$limit"
    ) -join "&"

    $uri = "$($this.BaseUrl)?$query"
    try {
      $resp = Invoke-RestMethod -Uri $uri -TimeoutSec $this.TimeoutSec -ErrorAction Stop
      if (-not $resp -or $resp.Count -le 1) { return @() }
      $rows = @()
      for ($i = 1; $i -lt $resp.Count; $i++) {
        $r = $resp[$i]
        if ($r.Count -lt 5) { continue }
        $rows += [pscustomobject]@{
          timestamp = [string]$r[0]
          original = [string]$r[1]
          statuscode = [string]$r[2]
          mimetype = [string]$r[3]
          digest = [string]$r[4]
        }
      }
      return $rows
    }
    catch {
      return @()
    }
  }
}

function Get-UniqueIntValuesFromUrls {
  param(
    [Parameter(Mandatory = $true)][object[]]$Rows,
    [Parameter(Mandatory = $true)][string]$Regex,
    [Parameter(Mandatory = $true)][int]$GroupIndex
  )

  $vals = New-Object System.Collections.Generic.List[int]
  foreach ($row in $Rows) {
    if ($row.original -match $Regex) {
      $vals.Add([int]$matches[$GroupIndex])
    }
  }
  return $vals | Sort-Object -Unique
}

function Get-KeyPairsFromUrls {
  param(
    [Parameter(Mandatory = $true)][object[]]$Rows,
    [Parameter(Mandatory = $true)][string]$Regex,
    [Parameter(Mandatory = $true)][string]$FirstKey,
    [Parameter(Mandatory = $true)][string]$SecondKey
  )

  $out = New-Object System.Collections.Generic.List[object]
  foreach ($row in $Rows) {
    if ($row.original -match $Regex) {
      $out.Add([pscustomobject]@{
        $FirstKey = [int]$matches[1]
        $SecondKey = [int]$matches[2]
        original = $row.original
        timestamp = $row.timestamp
        digest = $row.digest
      })
    }
  }

  return $out | Sort-Object $FirstKey, $SecondKey -Unique
}

$workspaceRoot = "c:\Users\Mark\Coding Projects\millsberry.com"
$outDir = Join-Path $workspaceRoot "recovery-osint"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$summaryPath = Join-Path $outDir "attack_coverage_summary.json"
if (-not (Test-Path $summaryPath)) {
  throw "Missing attack summary at $summaryPath"
}

$summary = Get-Content $summaryPath -Raw | ConvertFrom-Json
$knownGameIds = @($summary.game_ids | ForEach-Object { [int]$_ })

$client = [CdxClient]::new("https://web.archive.org/cdx/search/cdx", 40)

# Wildcard scans are much faster than probing individual candidates.
$patterns = [ordered]@{
  gamepages = "http://www.millsberry.com/gamepages/flashgame_ctp.phtml?game_id=*"
  hiscores = "http://www.millsberry.com/gamepages/hiscores.phtml?game_id=*"
  map_main = "http://graphics.millsberry.com/site_gfx/maps/mainmap_v*.swf"
  map_downtown = "http://graphics.millsberry.com/site_gfx/maps/downtown_v*.swf"
  map_winter = "http://graphics.millsberry.com/site_gfx/maps/mainmap_v*_winter.swf"
  map_fall = "http://graphics.millsberry.com/site_gfx/maps/mainmap_fall_v*.swf"
  interiors = "http://graphics.millsberry.com/game_interiors/interior_*_v*.swf"
  items = "http://graphics.millsberry.com/items/item_*.swf"
}

$limits = [ordered]@{
  gamepages = 20000
  hiscores = 20000
  map_main = 20000
  map_downtown = 20000
  map_winter = 20000
  map_fall = 20000
  interiors = 50000
  items = 50000
}

$rawResults = [ordered]@{}
foreach ($k in $patterns.Keys) {
  $rawResults[$k] = $client.Query($patterns[$k], $limits[$k])
}

$gameRows = @($rawResults.gamepages)
$hiscoreRows = @($rawResults.hiscores)
$mapRows = @($rawResults.map_main + $rawResults.map_downtown + $rawResults.map_winter + $rawResults.map_fall)
$interiorRows = @($rawResults.interiors)
$itemRows = @($rawResults.items)

$foundGameIds = Get-UniqueIntValuesFromUrls -Rows $gameRows -Regex 'game_id=(\d+)' -GroupIndex 1
$foundHiscoreIds = Get-UniqueIntValuesFromUrls -Rows $hiscoreRows -Regex 'game_id=(\d+)' -GroupIndex 1
$newGameIds = $foundGameIds | Where-Object { $_ -notin $knownGameIds }
$newHiscoreIds = $foundHiscoreIds | Where-Object { $_ -notin $knownGameIds }

$mapPairs = Get-KeyPairsFromUrls -Rows $mapRows -Regex '(?:mainmap|downtown)_v(\d+)(?:_winter)?\.swf|mainmap_fall_v(\d+)\.swf' -FirstKey 'versionA' -SecondKey 'versionB'
$mapVersions = New-Object System.Collections.Generic.List[int]
foreach ($m in $mapRows) {
  if ($m.original -match '_v(\d+)(?:_winter)?\.swf' -or $m.original -match '_fall_v(\d+)\.swf') {
    $mapVersions.Add([int]$matches[1])
  }
}
$mapVersions = $mapVersions | Sort-Object -Unique

$interiorPairs = Get-KeyPairsFromUrls -Rows $interiorRows -Regex 'interior_(\d+)_v(\d+)\.swf' -FirstKey 'id' -SecondKey 'version'
$interiorIds = @($interiorPairs | Select-Object -ExpandProperty id -Unique | Sort-Object)

$itemPairs = Get-KeyPairsFromUrls -Rows $itemRows -Regex 'item_(\d+)(?:_v(\d+))?\.swf' -FirstKey 'id' -SecondKey 'version'
$itemIds = @($itemPairs | Select-Object -ExpandProperty id -Unique | Sort-Object)

$huntReport = [pscustomobject]@{
  generated_at = (Get-Date).ToString("s")
  cdx_patterns = $patterns
  cdx_row_counts = [pscustomobject]@{
    gamepages = $gameRows.Count
    hiscores = $hiscoreRows.Count
    maps = $mapRows.Count
    interiors = $interiorRows.Count
    items = $itemRows.Count
  }
  game_ids = [pscustomobject]@{
    known_from_attack_summary = $knownGameIds
    found_via_cdx = $foundGameIds
    new_vs_attack_summary = $newGameIds
  }
  hiscore_ids = [pscustomobject]@{
    found_via_cdx = $foundHiscoreIds
    new_vs_attack_summary = $newHiscoreIds
  }
  map_versions_found = $mapVersions
  interior_ids_found = $interiorIds
  interior_pair_count = $interiorPairs.Count
  item_ids_found_sample = ($itemIds | Select-Object -First 400)
  item_pair_count = $itemPairs.Count
}

$reportPath = Join-Path $outDir "wayback_aggressive_hunt_report.json"
$huntReport | ConvertTo-Json -Depth 12 | Set-Content -Path $reportPath -Encoding UTF8

$gameRows | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $outDir "wayback_gamepages_hits.json") -Encoding UTF8
$hiscoreRows | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $outDir "wayback_hiscores_hits.json") -Encoding UTF8
$mapRows | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $outDir "wayback_map_hits.json") -Encoding UTF8
$interiorRows | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $outDir "wayback_interior_hits.json") -Encoding UTF8
$itemRows | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $outDir "wayback_item_hits.json") -Encoding UTF8

"REPORT`t$reportPath"
"NEW_GAME_IDS`t$([string]::Join(',', $newGameIds))"
"NEW_HISCORE_IDS`t$([string]::Join(',', $newHiscoreIds))"
"MAP_VERSIONS`t$([string]::Join(',', $mapVersions))"
"INTERIOR_IDS_COUNT`t$($interiorIds.Count)"
"ITEM_IDS_SAMPLE_COUNT`t$($itemIds.Count)"