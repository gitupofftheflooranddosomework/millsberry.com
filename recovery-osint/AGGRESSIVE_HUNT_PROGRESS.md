# Aggressive Hunt Progress

Generated: 2026-06-04

## Current Status
- Wayback CDX endpoint check: temporarily offline (public outage page observed).
- Local corpus mining completed against 2,548 SWF files.
- Imported additional normalized SWFs into active discovered set.

## New Imports
- First import batch: 15 files from github-extracted and sample assets.
- Normalized import batch: 108 files from archived path variants.
- Total newly imported this pass: 123 files.

## Updated Discovered Inventory
- Discovered SWF total: 147
- `int_*` scene files: 106
- `interior_*` files: 23
- map files (`mainmap*` + `downtown*`): 17

## Key High-Value Adds
- `downtown_v31.swf`
- `downtown_v32_winter.swf`
- `mainmap_v24.swf`
- `mainmap_v27.swf`
- `mainmap_v30.swf`
- `int_museum_v6.swf`
- `int_park_v19_winter.swf`
- `int_ravenwood_v14_winter.swf`
- `int_electronic_store_v3.swf`

## Artifact Outputs
- `recovery-osint/local_all_swf_paths.txt`
- `recovery-osint/local_corpus_new_swf_import_report.json`
- `recovery-osint/local_corpus_normalized_import_report.json`
- `recovery-osint/discovered_inventory_summary.json`

## Notes
- Many files include Wayback suffix noise (for example `__q...`) and were normalized before import.
- Existing game binary recovery report remains valid for `interior_*` and game-centric candidates.
- Next pass should decompile/index newly imported SWFs to extract route keys, loader params, and hidden asset references.
