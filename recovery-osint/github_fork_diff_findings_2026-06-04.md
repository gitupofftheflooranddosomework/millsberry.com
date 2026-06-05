# GitHub Fork Deep-Dive Findings (2026-06-04)

## Scope
- Fork and repo-level verification for public Millsberry-related GitHub targets.
- Full commit-history path mining on the highest-value candidates.
- Live validation and local extraction of recoverable binary artifacts.

## Fork Tree Diff (Current Trees)
Artifact: recovery-osint/github_millsberryjs_fork_tree_diff.json

- TylerTheLoser/Millsberry-JS
  - 4413 files
  - 0 SWF in current tree
  - 0 PHTML in current tree
  - 44 files under public/graphics
- andrezzasouza/Millsberry-JS
  - Same tree shape as Tyler fork for key counts
- karobelle/Millsberry-JS
  - Same tree shape as Tyler fork for key counts
- naestech/millsberry
  - 81 files
  - 0 SWF
  - 0 PHTML
  - 44 files under public/graphics
- reddude256/Millsberry-JS
  - 404 (currently unavailable)

Conclusion: current trees do not expose hidden SWF/PHTML payloads.

## Secondary Repo Verification
Artifact: recovery-osint/github_secondary_repo_tree_diff.json

- Doctor-Android/PDMillsberry: single-file public-domain stub
- nbrown1994/millsberry-remake: API 409 conflict (no tree payload available)
- Papaya12345/prayush: unrelated single-file repo

Conclusion: no additional recoverable binary signal from these repos in this pass.

## Historical Commit-History Mining (High-Value Result)
Artifacts:
- recovery-osint/github_history_scan_summary.json
- recovery-osint/github_history_hits_Millsberry-JS.txt
- recovery-osint/github_history_hits_MillsberryJS_commits.json
- recovery-osint/github_history_candidate_raw_urls.txt
- recovery-osint/github_history_candidate_raw_urls_live.txt

Method:
- Cloned TylerTheLoser/Millsberry-JS and naestech/millsberry.
- Enumerated all historical file paths with git log --all --name-only.
- Filtered for SWF/PHTML/game route/map/interior indicators.

Result:
- TylerTheLoser/Millsberry-JS historical paths include 17 SWF files.
- All 17 raw.githubusercontent.com commit-pinned URLs are live (HTTP 200).
- naestech/millsberry historical path scan returned 0 SWF/PHTML hits.

## Extracted SWFs (Recovered)
Artifacts:
- recovery-osint/github-extracted-swfs/
- recovery-osint/github_extracted_swf_manifest.json

Recovered file set (17):
- downtown_v24.swf
- mainmap_fall_v22.swf
- side_nav.swf
- top_nav.swf
- int_arcade_v3.swf
- int_classroom_v11.swf
- int_entertainment_v5.swf
- int_ext_com_center_v9_winter.swf
- int_gym_v1.swf
- int_hallway_v11.swf
- int_lab_v2.swf
- int_museum_v4.swf
- int_park_v13.swf
- int_police_v1.swf
- int_postoffice_v1.swf
- int_recording_studio_v1.swf
- sylvana_lake_with_sylvie_v8.swf

Total recovered payload size: 2,626,064 bytes.

## Primary Corpora Presence Check
Artifact: recovery-osint/github_extracted_swf_presence_in_primary_corpora.json

- Filename cross-check against primary datasets returned 0 matches for all 17 recovered SWFs in:
  - official-full-backup/
  - official-recovered-assets/
  - official-recovered/
  - official-core-recovered/
  - app/
  - another-user-backup-attempt/

Conclusion: by filename, this GitHub history pull appeared net-new to the current workspace corpora.

## Hash-Based Dedup Correction
Artifacts:
- recovery-osint/github_extracted_swf_hash_dedup.json
- recovery-osint/github_extracted_swf_hash_dedup_summary.json

Correction:
- Content-hash comparison (SHA256) shows all 17 recovered SWFs have duplicates, including duplicates in official corpora.
- Therefore these files are not net-new binaries; they are additional provenance paths and commit-pinned retrieval sources.

Key result:
- duplicate_in_official > 0 for all 17 recovered SWFs.

## What This Changes
- GitHub did contain recoverable historical Millsberry binaries, but in commit history rather than current branch trees.
- The highest-yield source in this pass is TylerTheLoser/Millsberry-JS historical commits.

## Next GitHub Attack Steps
1. Enumerate all forks/watchers of TylerTheLoser/Millsberry-JS and repeat full git-log path mining.
2. Scan tags/releases and attached artifacts for each fork.
3. Mine commit diffs for removed file blobs beyond file-name-only enumeration.
4. Compare recovered SWF set against local official-recovered-assets corpus to identify true net-new files.
