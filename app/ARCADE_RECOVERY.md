# Millsberry Arcade Recovery

## Recovered Source

- Internet Archive item: `millsberry_cache`
- Artifact: `flashgames.zip`
- Description: Millsberry browser cache preserved in 2010
- Untouched imported SWFs are retained in `recovered-games/originals/`.
- Runtime-compatible copies are served from `recovered-games/`.
- Authentic alternate-host builds are retained under their surviving distributor filenames.

## Known Game IDs

`12, 13, 16, 18, 19, 60, 80, 100, 140, 160, 180, 220, 240, 260, 300, 320, 340, 360, 380, 400, 420, 440, 484, 486, 505, 510, 511, 515, 520, 525, 535`

## Recovered Games

| ID | Title | Main file | State |
| --- | --- | --- | --- |
| 12 | Solver | `g12_v9.swf` | Binary recovered; authentic dictionary recovered; startup still stalls in Ruffle |
| 18 | Peanut Butter Toast Crunch Swirl | `g18_v11.swf` | Gameplay browser-verified |
| 300 | Lucky Charms: Charmed Life | `neopets_g737_v12_44097.swf` | Authentic Neopets distribution recovered; runtime verification pending |
| 340 | Wave Blaster | `g340_v9.swf` | Binary recovered; startup timeline still stalls in Ruffle |
| 400 | Black Belt Karate | `g400_v14.swf` | Title screen browser-verified |
| 505 | Horton Hears a Who: Water Water Everywhere | `pji_horton.swf` plus `main_waterwater.swf`, sound, language, font, and configuration assets | Authentic distributor package recovered; gameplay browser-verified |
| 510 | Millsberry 500 | `g510_v1.swf` plus `racing/` | Title screen and dependency loading browser-verified |
| 511 | Save the Honey | `g511_v1.swf` plus `savethehoney_game/` | Dependencies recovered; level-one startup still stalls in Ruffle |

## Additional Preserved Arcade Builds

These valid SWFs were distributed outside Millsberry and are retained in
`recovered-games/variants/` until their Millsberry IDs and launcher parameters
are confirmed:

- `neopets_g422_v1_87147.swf` - Cinnamon Toast Crunch Swirl
- `neopets_g392_v10_61253.swf` - Cocoa Puffs Crossword
- `MunkBeat.swf` - The Squeakquel: Munk to the Beat

## New Recovery Hashes

| File | SHA-256 |
| --- | --- |
| `neopets_g737_v12_44097.swf` | `618019BA8AF913825A4CE11830929C21F1B3D1990DE6C57984C84696BB3CCAE3` |
| `pji_horton.swf` | `37FFF804F9CFD43F6DBBC9C9FEEE5B62F6593E0C8019B4A3AD56D2D829198C28` |
| `main_waterwater.swf` | `2A58D9893337813DCE9D2EC3716DF6EBED14B791318047EE95FF244E55009B04` |
| `sounds_waterwater.swf` | `6E677A46567221351719221BF89BE549A5DD1C09EF0623AD788062107607D798` |
| `assets/en-assets.swf` | `D63DE64740B2AC0B0EE2FEC406B2DEE146E708950FE33441DA32E2BBC1210597` |
| `assets/base-fonts.swf` | `9B4BEBE99E3F4EBD30A28D05053E43B2FF6B8567D1CC4AC87674D3FCAC094541` |
| `international.xml` | `F4C0A8E85E312C8B99B2595222D2BABDBF78F237CD81BDCE2EB6AC7194B83BE8` |
| `neopets_g422_v1_87147.swf` | `0E87F379B56C9BEDCACF7DE68D8BCB4E00219D7046B6E44F8AC79EB061D9EA4C` |
| `neopets_g392_v10_61253.swf` | `6C55D1B2B38F493C7D421ABE23E6D4AA16086C16E70970E7C1F9F8A9D64D7D20` |
| `MunkBeat.swf` | `73FE097C8FF292B1688AE4D90960CA55D519623FAC01A7FFF50C0F6D6D8495D3` |

## Shared Runtime Recovery

- Official Ruffle nightly `nightly-2026-06-04` is vendored in `vendor/ruffle/`.
- The surviving Neopets Flash BIOS and `np6_include_v1.swf` were recovered for analysis.
- The surviving `flash_dictionary_en_v18.swf` was recovered for Solver.
- Missing Millsberry `bios.swf` and `mb7_include.swf` behavior is replaced only where required by small compatibility patches.

## Remaining Recovery Targets

The other known game IDs have archived launch pages but no game binary in the recovered cache. Continue searching:

- Wayback captures under Millsberry host aliases and the historical IP `64.191.225.20`
- Additional browser caches and Flashpoint Discord preservation uploads
- Internet Archive items containing Millsberry or General Mills Flash caches
- Old Flashpoint database revisions and removed extras
