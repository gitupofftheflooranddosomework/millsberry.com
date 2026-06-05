$ErrorActionPreference = "Stop"
$outDir = "recovery-osint"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
Write-Output "RECOVERY_SWEEPER`tSTART"

function Get-GeneralMillsMirrorCandidates {
  param(
    [Parameter(Mandatory = $true)][string[]]$SourceUrls
  )

  $mirrorCandidates = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
  $pathPrefixes = @(
    "old",
    "old/millsberry.com",
    "archive",
    "archived",
    "legacy",
    "millsberry",
    "sites/millsberry"
  )

  foreach ($sourceUrl in $SourceUrls) {
    if ([string]::IsNullOrWhiteSpace($sourceUrl)) { continue }

    try {
      $parsed = [uri]$sourceUrl
    }
    catch {
      continue
    }

    $relativePath = $parsed.AbsolutePath.TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($relativePath)) { continue }

    $segments = @(
      $relativePath,
      "$($parsed.Host)/$relativePath"
    ) | Sort-Object -Unique

    foreach ($prefix in $pathPrefixes) {
      foreach ($segment in $segments) {
        $candidatePath = if ([string]::IsNullOrWhiteSpace($prefix)) {
          "/$segment"
        } else {
          "/$prefix/$segment"
        }

        $builder = [System.UriBuilder]::new("https", "www.generalmills.com")
        $builder.Path = $candidatePath
        $builder.Query = $parsed.Query.TrimStart('?')
        [void]$mirrorCandidates.Add($builder.Uri.AbsoluteUri)
      }
    }
  }

  return $mirrorCandidates | Sort-Object
}

$files = Get-ChildItem -Recurse -File | Where-Object {
  $_.FullName -notmatch "\\.git\\" -and $_.Extension -in ".json", ".txt", ".md", ".phtml", ".as", ".js", ".css", ".html", ".htm", ".csv", ".yml"
}
Write-Output "RECOVERY_SWEEPER`tFILES`t$($files.Count)"

$textParts = foreach ($f in $files) {
  try { Get-Content $f.FullName -Raw -ErrorAction Stop } catch { "" }
}
$allText = ($textParts -join "`n")

$rawHosts = [regex]::Matches($allText, '(?i)https?://([^/"''\s<>]+)') | ForEach-Object { $_.Groups[1].Value.ToLower().Trim() }
$noisePatterns = @(
  "^wwwb-app\\d+\\.us\\.archive\\.org$",
  "^archive\\.org$",
  "^web\\.archive\\.org$",
  "^faq\\.web\\.archive\\.org$",
  "^analytics\\.archive\\.org$",
  "^rdap\\.verisign\\.com$",
  "^download\\.macromedia\\.com$",
  "^active\\.macromedia\\.com$",
  "^ad\\.doubleclick\\.net$",
  "^fls\\.doubleclick\\.net$",
  "^n4403ad\\.doubleclick\\.net$"
)
$hosts = $rawHosts |
  Where-Object { $_ -match "[a-z0-9\\.-]+" -and $_ -notmatch "[\\x00-\\x1F]" } |
  ForEach-Object { $_ -replace ":80$", "" -replace "\\.$", "" } |
  Sort-Object -Unique
$cleanHosts = $hosts | Where-Object {
  $h = $_
  -not ($noisePatterns | ForEach-Object { $h -match $_ } | Where-Object { $_ })
}
$cleanHosts | Set-Content -Path (Join-Path $outDir "attack_hosts_all.txt")

$gameIds = [regex]::Matches($allText, "(?i)game_id=(\\d+)") | ForEach-Object { [int]$_.Groups[1].Value } | Sort-Object -Unique
$maxGame = if ($gameIds.Count -gt 0) { [Math]::Max(600, ($gameIds | Measure-Object -Maximum).Maximum) } else { 600 }
$missingGames = 1..$maxGame | Where-Object { $gameIds -notcontains $_ }

$mapMatches = [regex]::Matches($allText, "(?i)(mainmap|downtown)_v(\\d+)(?:_(winter|fall|spring|summer))?\\.swf")
$mapObjs = $mapMatches | ForEach-Object {
  [pscustomobject]@{
    map = $_.Groups[1].Value.ToLower()
    version = [int]$_.Groups[2].Value
    season = $_.Groups[3].Value.ToLower()
  }
}
$mapUnique = $mapObjs | Sort-Object map, version, season -Unique

$interiorMatches = [regex]::Matches($allText, "(?i)interior_(\\d+)_v(\\d+)\\.swf")
$interiorObjs = $interiorMatches | ForEach-Object {
  [pscustomobject]@{ id = [int]$_.Groups[1].Value; version = [int]$_.Groups[2].Value }
}
$interiorUnique = $interiorObjs | Sort-Object id, version -Unique
$interiorIds = $interiorUnique.id | Sort-Object -Unique
$maxInterior = if ($interiorIds.Count -gt 0) { [Math]::Max(600, ($interiorIds | Measure-Object -Maximum).Maximum) } else { 600 }
$missingInteriorIds = 1..$maxInterior | Where-Object { $interiorIds -notcontains $_ }

$itemMatches = [regex]::Matches($allText, "(?i)item_(\\d+)(?:_v(\\d+))?\\.swf")
$itemObjs = $itemMatches | ForEach-Object {
  [pscustomobject]@{
    id = [int]$_.Groups[1].Value
    version = if ($_.Groups[2].Value) { [int]$_.Groups[2].Value } else { $null }
  }
}
$itemUnique = $itemObjs | Sort-Object id, version -Unique
$itemIds = $itemUnique.id | Sort-Object -Unique

$neopetsDomains = [regex]::Matches($allText, "(?i)\\b(?:[a-z0-9-]+\\.)*neopets\\.com\\b") | ForEach-Object { $_.Value.ToLower() } | Sort-Object -Unique
$ipMatches = [regex]::Matches($allText, "\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b") | ForEach-Object { $_.Value } | Sort-Object -Unique
$pivotIps = $ipMatches | Where-Object { $_ -match "^64\\.191\\.225\\." -or $_ -match "^209\\.34\\." -or $_ -match "^10\\.100\\.56\\." -or $_ -eq "172.16.26.10" }

$candidateGameUrls = $missingGames | ForEach-Object { "http://www.millsberry.com/gamepages/flashgame_ctp.phtml?game_id=$_" }
$candidateHiscoreUrls = $missingGames | ForEach-Object { "http://www.millsberry.com/gamepages/hiscores.phtml?game_id=$_" }

$candidateMapUrls = @()
foreach ($v in 1..60) {
  $candidateMapUrls += "http://graphics.millsberry.com/site_gfx/maps/mainmap_v$v.swf"
  $candidateMapUrls += "http://graphics.millsberry.com/site_gfx/maps/downtown_v$v.swf"
  $candidateMapUrls += "http://graphics.millsberry.com/site_gfx/maps/mainmap_v${v}_winter.swf"
  $candidateMapUrls += "http://graphics.millsberry.com/site_gfx/maps/mainmap_fall_v$v.swf"
}

$candidateInteriorUrls = foreach ($id in ($missingInteriorIds | Select-Object -First 1200)) {
  foreach ($ver in 1..6) { "http://graphics.millsberry.com/game_interiors/interior_${id}_v$ver.swf" }
}

$candidateItemUrls = foreach ($id in 1..20000) {
  foreach ($ver in 1..4) { "http://graphics.millsberry.com/items/item_${id}_v$ver.swf" }
}

# Generate a separate General Mills mirror list so the baseline Millsberry candidates remain stable.
$candidateGeneralMillsMirrorUrls = Get-GeneralMillsMirrorCandidates -SourceUrls @(
  $candidateGameUrls
  $candidateHiscoreUrls
  $candidateMapUrls
  $candidateInteriorUrls
  $candidateItemUrls
)
Write-Output "RECOVERY_SWEEPER`tMIRROR_CANDIDATES`t$($candidateGeneralMillsMirrorUrls.Count)"

$coverage = [pscustomobject]@{
  generated_at = (Get-Date).ToString("s")
  game_ids_found = $gameIds
  game_id_found_count = $gameIds.Count
  game_id_missing_count = $missingGames.Count
  game_id_missing_sample = ($missingGames | Select-Object -First 300)
  map_assets_found = ($mapUnique | ForEach-Object { if ($_.season) { "{0}_v{1}_{2}.swf" -f $_.map, $_.version, $_.season } else { "{0}_v{1}.swf" -f $_.map, $_.version } })
  map_asset_count = $mapUnique.Count
  interior_asset_count = $interiorUnique.Count
  interior_ids_found = $interiorIds
  interior_missing_count = $missingInteriorIds.Count
  interior_missing_sample = ($missingInteriorIds | Select-Object -First 300)
  item_ids_found_count = $itemIds.Count
  item_ids_found_sample = ($itemIds | Select-Object -First 300)
  item_id_max_observed = if ($itemIds.Count -gt 0) { ($itemIds | Measure-Object -Maximum).Maximum } else { 0 }
  generalmills_mirror_candidate_count = $candidateGeneralMillsMirrorUrls.Count
  host_count = $cleanHosts.Count
  hosts = $cleanHosts
  neopets_domains = $neopetsDomains
  pivot_ips = $pivotIps
}
$coverage | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $outDir "attack_coverage_summary.json")

$neopetsPivot = [pscustomobject]@{
  generated_at = (Get-Date).ToString("s")
  neopets_domains = $neopetsDomains
  gmidev_hits = ([regex]::Matches($allText, "(?i)gmidev\\.neopets\\.com") | Measure-Object).Count
  fg_script_base_hits = ([regex]::Matches($allText, "(?i)FG_SCRIPT_BASE") | Measure-Object).Count
  fg_game_base_hits = ([regex]::Matches($allText, "(?i)FG_GAME_BASE") | Measure-Object).Count
  allowdomain_hits = ([regex]::Matches($allText, "(?i)allowDomain\(") | Measure-Object).Count
  pivot_ips = $pivotIps
  candidate_wayback_queries = @(
    "https://web.archive.org/web/*/gmidev.neopets.com/*",
    "https://web.archive.org/web/*/dev.neopets.com/high_scores/fg_get_info.phtml*",
    "https://web.archive.org/web/*/webdev.neopets.com/*",
    "https://web.archive.org/web/*/images50.neopets.com/*",
    "https://web.archive.org/web/*/graphics.millsberry.com/gamingsystem/flash8/*"
  )
}
$neopetsPivot | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $outDir "neopets_pivots.json")

$candidateGameUrls | Set-Content -Path (Join-Path $outDir "candidate_missing_game_urls.txt")
$candidateHiscoreUrls | Set-Content -Path (Join-Path $outDir "candidate_missing_hiscore_urls.txt")
$candidateMapUrls | Set-Content -Path (Join-Path $outDir "candidate_map_urls.txt")
$candidateInteriorUrls | Set-Content -Path (Join-Path $outDir "candidate_interior_urls.txt")
$candidateItemUrls | Set-Content -Path (Join-Path $outDir "candidate_item_urls.txt")
$candidateGeneralMillsMirrorUrls | Set-Content -Path (Join-Path $outDir "candidate_generalmills_mirror_urls.txt")

$highestItemIdObserved = if ($itemIds.Count -gt 0) {
  ($itemIds | Measure-Object -Maximum).Maximum
} else {
  0
}

$reportPath = Join-Path $outDir "COVERAGE_GAPS.md"
$lines = @(
  "# Coverage Gaps",
  "",
  "Generated: " + (Get-Date).ToString("u"),
  "",
  "- Host count: " + $cleanHosts.Count,
  "- Game IDs found: " + $gameIds.Count,
  "- Missing game IDs up to ${maxGame}: " + $missingGames.Count,
  "- Map assets found: " + $mapUnique.Count,
  "- Interior assets found: " + $interiorUnique.Count,
  "- Interior IDs missing up to ${maxInterior}: " + $missingInteriorIds.Count,
  "- Item IDs observed: " + $itemIds.Count,
  "- Highest item ID observed: " + $highestItemIdObserved,
  "- General Mills mirror candidates: " + $candidateGeneralMillsMirrorUrls.Count,
  "",
  "## Key Pivot Domains",
  ($cleanHosts | Select-Object -First 80),
  "",
  "## Neopets Domains",
  $neopetsDomains,
  "",
  "## Pivot IPs",
  $pivotIps,
  "",
  "## Generated Mirror Artifact",
  "- candidate_generalmills_mirror_urls.txt",
  "- Heuristic rewrites of baseline Millsberry candidate URLs into likely www.generalmills.com archive or legacy paths.",
  "",
  "## Missing Game ID Sample",
  ($missingGames | Select-Object -First 250)
)
$lines | Set-Content -Path $reportPath

"WROTE_FILES"
Get-ChildItem $outDir -File | Where-Object { $_.Name -like "attack_*" -or $_.Name -like "neopets_*" -or $_.Name -like "candidate_*" -or $_.Name -eq "COVERAGE_GAPS.md" } | Select-Object Name, Length
Write-Output "RECOVERY_SWEEPER`tDONE"
