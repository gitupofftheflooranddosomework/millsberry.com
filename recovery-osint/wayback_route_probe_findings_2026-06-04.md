# Wayback Route Probe Findings (2026-06-04)

## Context
Wayback endpoints are unstable (timeouts/503) so probing was executed in small batches to force reliable completion.

## Interior URL Probing
- Superset baseline test:
  - Batch size: 600
  - Hits: 0
  - Miss: 600
  - Artifacts expected from this run were not persisted due prior stalled session.

- Targeted extras test (10 newly discovered interior URLs):
  - Hits: 1
  - Miss: 9
  - Confirmed hit:
    - http://graphics.millsberry.com/game_interiors/interior_484_v1.swf
    - http://web.archive.org/web/20070814010101/http://graphics.millsberry.com/game_interiors/interior_484_v1.swf

## Missing Route Candidate Probing (Micro-Batches)
- flashgame missing candidates
  - batch1a (offset 0, size 25): 0 hits, 25 miss
  - batch1b (offset 25, size 25): 0 hits, 25 miss

- hiscore missing candidates
  - batch1a (offset 0, size 25): 0 hits, 25 miss
  - batch1b (offset 25, size 25): 0 hits, 25 miss

## Known ID Route Validation
Using corpus-confirmed IDs (12, 13, 16, 80, 180), route probing returned 5 hits (all flashgame_ctp):
- http://web.archive.org/web/20060105100609/http://www.millsberry.com:80/gamepages/flashgame_ctp.phtml?game_id=12
- http://web.archive.org/web/20051210130026/http://www.millsberry.com:80/gamepages/flashgame_ctp.phtml?game_id=13
- http://web.archive.org/web/20051210140538/http://www.millsberry.com:80/gamepages/flashgame_ctp.phtml?game_id=16
- http://web.archive.org/web/20060105084014/http://www.millsberry.com:80/gamepages/flashgame_ctp.phtml?game_id=80
- http://web.archive.org/web/20060105100954/http://www.millsberry.com:80/gamepages/flashgame_ctp.phtml?game_id=180

## Decoded Embedded SWF Recovery (Major Result)
Method:
- Pulled archived HTML for the 5 confirmed route replays.
- Decoded nested percent-encoded itemLoaderXML payloads to extract embedded graphics URLs.

Decoded embedded SWFs found (7):
- http://graphics.millsberry.com/game_interiors/interior_12_v3.swf
- http://graphics.millsberry.com/game_interiors/interior_13_v2.swf
- http://graphics.millsberry.com/game_interiors/interior_16_v3.swf
- http://graphics.millsberry.com/game_interiors/interior_80_v1.swf
- http://graphics.millsberry.com/site_gfx/stat_icon_fitness_v1.swf
- http://graphics.millsberry.com/site_gfx/stat_icon_civics_v1.swf
- http://graphics.millsberry.com/site_gfx/stat_icon_intelligence_v1.swf

Wayback validation on decoded SWFs:
- Hits: 4
- Miss: 3

Downloaded decoded interior SWFs (4):
- interior_12_v3.swf
- interior_13_v2.swf
- interior_16_v3.swf
- interior_80_v1.swf

Hash dedup result:
- All 4 decoded extracted interiors currently show duplicate_count=0 in scanned workspace corpora (unique by hash in this pass).

## Full-Corpus Payload Decode Extension
Extended decoding across the full local corpus (not only the 5 known route replay pages) found an additional embedded interior URL not present in the interior superset candidate list:
- http://graphics.millsberry.com/game_interiors/interior_300_v4.swf

Validation and extraction:
- Wayback hit confirmed and downloaded to recovery-osint/wayback-extracted-interiors/interior_300_v4.swf
- Hash check shows duplicate_count=0 in scanned workspace corpora (unique by hash in this pass).

## Artifacts
- recovery-osint/probe_hits_interiors_extra_wayback.json
- recovery-osint/probe_miss_interiors_extra_wayback.json
- recovery-osint/probe_hits_missing_game_wayback_batch1a.json
- recovery-osint/probe_miss_missing_game_wayback_batch1a.json
- recovery-osint/probe_hits_missing_game_wayback_batch1b.json
- recovery-osint/probe_miss_missing_game_wayback_batch1b.json
- recovery-osint/probe_hits_missing_hiscore_wayback_batch1a.json
- recovery-osint/probe_miss_missing_hiscore_wayback_batch1a.json
- recovery-osint/probe_hits_missing_hiscore_wayback_batch1b.json
- recovery-osint/probe_miss_missing_hiscore_wayback_batch1b.json
- recovery-osint/probe_hits_known_ids_wayback.json
- recovery-osint/probe_miss_known_ids_wayback.json
- recovery-osint/wayback_known_id_route_replay_urls.txt
- recovery-osint/wayback_route_probe_summary_2026-06-04.json
- recovery-osint/known_id_route_page_decoded_embedded_assets.json
- recovery-osint/known_id_route_page_decoded_embedded_asset_urls.txt
- recovery-osint/known_id_route_page_decoded_embedded_swf_urls.txt
- recovery-osint/decoded_embedded_swf_wayback_hits.json
- recovery-osint/decoded_embedded_swf_wayback_miss.json
- recovery-osint/wayback-extracted-decoded-swfs/
- recovery-osint/wayback_extracted_decoded_swf_hash_check.json
- recovery-osint/corpus_decoded_embedded_interior_swf_urls.txt
- recovery-osint/corpus_decoded_embedded_interior_extras_over_superset.txt
- recovery-osint/probe_interior_300_v4_wayback.json
- recovery-osint/wayback_extracted_interior_300_v4_hash_check.json

## Interpretation
- Synthetic missing-route candidates are currently low-yield under live Wayback checks.
- Corpus-grounded route IDs produce validated archive hits and should be prioritized for expansion.
- Decoding embedded payloads inside confirmed route pages is high-yield and produced unique interior SWF recoveries.

## Current Unique Wayback Interior Recovery Inventory
Artifact:
- recovery-osint/wayback_unique_interior_recoveries_manifest.json

Recovered unique interiors in this phase (6):
- interior_12_v3.swf
- interior_13_v2.swf
- interior_16_v3.swf
- interior_80_v1.swf
- interior_300_v4.swf
- interior_484_v1.swf
