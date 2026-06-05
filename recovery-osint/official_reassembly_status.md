# Official Millsberry reassembly status

Date: 2026-06-04

## Scope correction

This workspace is now split so the General Mills recovery track contains only original Millsberry / Mills Online / General Mills material from public archives and DNS records.

Fan or unrelated reconstruction material was moved to:

- `another-user-backup-attempt/Millsberry-JS`
- `another-user-backup-attempt/broad-wayback-pass`

The official recovery folders are:

- `official-full-backup`
- `official-recovered-assets`
- `official-recovered`
- `recovery-osint`

The current single-file archive is:

- `official-full-backup.zip`

## Official recovered asset inventory

Merged full official backup:

- Folder: `official-full-backup`
- Archive: `official-full-backup.zip`
- Files: 3,809
- Size: about 156 MB uncompressed, about 133 MB compressed
- Manifest coverage:
  - Domain-level official non-home manifest: 3,549 of 4,072 rows present by digest.
  - Host-level graphics/branded manifests: 1,670 of 1,702 rows present by digest.
- Remaining missing rows are mostly HTML captures that Wayback timed out on after repeated attempts.

Clean official asset tree:

- Folder: `official-recovered-assets`
- Files: 1,695
- Size: about 112 MB
- Major file types:
  - 754 SWF files
  - 690 GIF files
  - 88 JPG files
  - 62 JS files
  - 52 PNG files
  - 24 CSS files
  - 7 PDFs
  - 4 Unity3D files
  - 3 ICO files
  - 2 XML files

Assets by original host:

- `graphics.millsberry.com`: 851 files
- `devgraphics.millsberry.com`: 395 files
- `www.millsberry.com`: 220 files
- `millsberry.com`: 42 files
- `www.sillyrabbit.millsberry.com`: 41 files
- `www.luckycharms.millsberry.com`: 38 files
- `dev2graphics.millsberry.com`: 37 files
- `www.nutsabouthoney.millsberry.com`: 24 files
- `www.honeydefender.millsberry.com`: 18 files
- `www.luckycharmsfun.millsberry.com`: 10 files
- `dev.millsberry.com`: 6 files
- `honeydefender.millsberry.com`: 6 files
- `www.honeynutcheerios.millsberry.com`: 6 files
- `dev2.millsberry.com`: 1 file

Partial official page tree:

- Folder: `official-recovered`
- Files: 193 downloaded before Wayback started timing out heavily.
- These are original archived pages, mostly `millsberry.com` / `www.millsberry.com` captures.

Targeted core page tree:

- Folder: `official-core-recovered`
- Files: 100 recovered before Wayback timed out.
- Size: about 4.9 MB.
- Contents include original app pages for:
  - Academy
  - Bank
  - Buddy change flow
  - Community Center / Dojo / Donation Center
  - Complex / Arcade
  - Game pages, high scores, and `flashgame_ctp.phtml`
  - Inventory
  - Farm
  - Crater
  - `history-of-millsberry.pdf`

## Official manifests and route inventories

- `official_wayback_no_home.csv`: official-only archive manifest from Millsberry-owned hosts.
- `official_assets_manifest.csv`: official non-HTML asset manifest.
- `official_asset_extracted_references.csv`: references extracted from recovered official assets, including SWF binary string extraction.
- `official_routes_phtml.txt`: 234 PHTML route references.
- `official_api_like_routes.txt`: 62 API-like or process/XML route references.
- `official_asset_references.txt`: 629 asset references.
- `official_external_references.txt`: 604 URL references.
- `official_core_pages_manifest.json`: targeted official app/core page manifest.
- `official_full_backup_inventory.csv`: SHA-256 inventory for all files in `official-full-backup`.
- `official_full_backup_summary.json`: file/byte counts by host and extension.
- `official_full_backup_tree.txt`: compact directory/tree index.
- `official_full_file_references.csv`: references extracted from the merged full backup.
- `official_full_phtml_references.txt`: 1,689 PHTML references extracted from the merged full backup.
- `official_full_swf_references.txt`: 1,350 SWF references extracted from the merged full backup.
- `official_full_url_references.txt`: 1,880 Millsberry/General Mills URLs extracted from the merged full backup.
- `official_full_api_like_routes.txt`: 75 process/XML/ajax-like routes extracted from the merged full backup.
- `official_manifest_missing_by_digest.csv`: domain-level official manifest rows still missing by digest.
- `official_extended_host_missing_after_backup.csv`: host-level rows still missing by digest.

## Important recovered route/API clues

Known dynamic endpoints and process routes include:

- `/buddy/process_buddy.phtml`
- `/process_buddy_list.phtml`
- `/process_shortcut.phtml`
- `/process_break_time.phtml`
- `/complex/process_theater.phtml`
- `/complex/process_theater_tr.phtml`
- `/colhurst/process_tunnels.phtml`
- `/campaigns/frudare2010/ajax.phtml`
- `/top_nav_xml.phtml`
- `/side_nav_xml.phtml`
- `/load_buddy_xml.phtml`
- `/process_signup.phtml`
- `process_colhurst.phtml`

Game and app page routes found include:

- `/gamepages/flashgame_ctp.phtml`
- `/gamepages/hiscores.phtml`
- `/gamepages/games_list.phtml`
- `/main_map.phtml`
- `/shop.phtml`
- `/inventory.phtml`
- `/bank/`
- `/peabody_park/`
- `/post_office/`
- `/studio.phtml`
- `/town_hall/historical_society.phtml`
- `/classifieds.phtml`
- `/complex/arcade.phtml`
- `/complex/theater.phtml`

Recovered game IDs seen in route references include:

- `12`, `13`, `18`, `19`, `100`, `140`, `160`, `240`, `300`, `360`, `380`, `400`, `440`, `484`, `486`, `511`

## High-value recovered SWF categories

Recovered official SWFs include:

- Main maps: `mainmap_*`, `downtown_*`
- Building/interior scenes: `int_*`
- Home/avatar engines: `home_*`, `buddy_featured_*`
- Shared loaders/navigation: `item_loader_*`, `side_nav*`, `top_nav*`
- Brand minisites: Trix/Silly Rabbit, Lucky Charms, Nuts About Honey, Honey Defender
- Theater/arcade-related assets
- Registration/legal/privacy SWFs

## Infrastructure leads still highest priority

Original DNS records still point to old infrastructure:

- `graphics.millsberry.com` -> `209.34.86.51`
- `dev.millsberry.com` -> `209.34.87.112`
- `dev2.millsberry.com` -> `209.34.87.112`
- `devgraphics.millsberry.com` -> `209.34.87.107`
- `dev2graphics.millsberry.com` -> `209.34.87.107`

These should be checked from inside General Mills network/vendor records. If the disks or VM images still exist, that is the only likely path to original PHP/PHTML server source and database schemas.

## Next technical recovery steps

1. Decompile official SWFs to ActionScript and asset timelines.
2. Build an endpoint contract map from SWF calls to `process_*`, `*_xml.phtml`, and `ajax.phtml`.
3. Reconstruct a static browseable archive from recovered HTML/assets.
4. Rebuild minimal server stubs for XML/API endpoints from SWF expectations.
5. Search General Mills internal systems for old source using the route names above.
6. Search vendor/hosting records for the `209.34.*` host IPs and old dev hostnames.
