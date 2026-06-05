# Local Corpus Asset Discovery (2026-06-04)

## Why This Pass
Live Wayback/CDX queries were intermittently failing (503/timeouts), so this pass mined local backup/recovery corpora for embedded SWF URLs.

## Sources Scanned
- official-full-backup/
- official-recovered-assets/
- official-recovered/
- official-core-recovered/
- another-user-backup-attempt/
- app/
- recovery-analysis/
- recovery-osint/

## Extraction Pattern
- Normalized URLs matching:
  - graphics.millsberry.com/game_interiors/*.swf
  - graphics.millsberry.com/items/*.swf
- Also normalized Wayback replay wrappers to origin URLs.

## Results
- Interiors discovered: 3418
- Items discovered: 80000
- Maps discovered: 240

Artifacts:
- recovery-osint/local_discovered_game_interiors_urls.txt
- recovery-osint/local_discovered_items_urls.txt
- recovery-osint/local_discovered_map_urls.txt

## Candidate Comparison
- Interior candidates (existing): 3408
- Interior discovered (local corpus): 3418
- Net new interiors over candidate list: 10
- Interior candidates not seen in local corpus: 0

- Item candidates (existing): 80000
- Item discovered (local corpus): 80000
- Net new items over candidate list: 0
- Item candidates not seen in local corpus: 0

- Map candidates (existing): 240
- Map discovered (local corpus): 240
- Net new maps over candidate list: 0
- Map candidates not seen in local corpus: 0

Artifacts:
- recovery-osint/local_discovered_interiors_extra_over_candidates.txt
- recovery-osint/candidate_interiors_not_seen_in_local_corpus.txt
- recovery-osint/local_discovered_items_extra_over_candidates.txt
- recovery-osint/candidate_items_not_seen_in_local_corpus.txt
- recovery-osint/local_discovered_maps_extra_over_candidates.txt
- recovery-osint/candidate_maps_not_seen_in_local_corpus.txt

## New Interior URLs (10)
- http://graphics.millsberry.com/game_interiors/interior_420_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_440_v3.swf
- http://graphics.millsberry.com/game_interiors/interior_484_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_486_v2.swf
- http://graphics.millsberry.com/game_interiors/interior_505_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_510_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_511_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_515_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_520_v1.swf
- http://graphics.millsberry.com/game_interiors/interior_525_v1.swf

## Updated Probe Input
- recovery-osint/candidate_interior_urls_superset.txt (3418 URLs)

## Live Probe Note
- During this pass, Wayback CDX and availability endpoints were intermittently unavailable (timeouts/503), so the validated output is corpus-derived and normalization-based rather than fully live-probed.

## Targeted Wayback Validation (Extra 10 Interiors)
Artifacts:
- recovery-osint/probe_hits_interiors_extra_wayback.json
- recovery-osint/probe_miss_interiors_extra_wayback.json

Result:
- Checked 10 newly discovered interior URLs via Wayback availability API.
- 1 archived hit found:
  - http://graphics.millsberry.com/game_interiors/interior_484_v1.swf
  - archive replay: http://web.archive.org/web/20070814010101/http://graphics.millsberry.com/game_interiors/interior_484_v1.swf

Extraction:
- Downloaded to recovery-osint/wayback-extracted-interiors/interior_484_v1.swf
- Size: 10843 bytes
- Hash check indicates duplicate_count=0 across scanned workspace SWFs (unique in current corpus scan).

Integrity artifact:
- recovery-osint/wayback_extracted_interiors_manifest.json
- recovery-osint/wayback_extracted_interior_484_hash_check.json
