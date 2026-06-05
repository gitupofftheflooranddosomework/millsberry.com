# GitHub OSINT Findings (2026-06-04)

## Confirmed Findings

### 1) TylerTheLoser/Millsberry-JS
- URL: https://github.com/TylerTheLoser/Millsberry-JS
- Confidence: High
- What is confirmed:
  - Millsberry rewrite project with archived graphics references
  - Hardcoded references to graphics.millsberry.com in CSS
  - Wayback snapshot HTML artifacts for graphics paths
  - Historical commit graph includes recoverable SWF binaries (17 files) not exposed in current tree
- Notable evidence:
  - css/royal.css references graphics.millsberry.com layout assets
  - css/template.css references graphics.millsberry.com nav/title assets
  - public/graphics/visit_* files include web.archive.org capture links for graphics.millsberry.com assets
  - Commit-history extraction yielded live raw URLs and local recovery of 17 SWFs (see deep-dive report)

### 2) juvian/neopets-flash-fix
- URL: https://github.com/juvian/neopets-flash-fix
- Confidence: Medium (methodology value, not direct Millsberry assets)
- What is confirmed:
  - Uses game_id routing patterns in Neopets game URLs
  - Contains practical flash preservation and score-submission workaround workflows
- Notable evidence:
  - README includes game_id query patterns and extraction/download workflow

## Negative/Low-Yield Findings

### FlashpointProject org search
- Scope searched: FlashpointProject
- Query class: millsberry and related route/host terms
- Result: No direct Millsberry string matches via GitHub text search in this pass

### Fork Tree Diff Results (Millsberry-JS lineage)
- Artifact: recovery-osint/github_millsberryjs_fork_tree_diff.json
- Findings:
  - TylerTheLoser/Millsberry-JS: 4413 files, 0 SWF, 0 PHTML, 44 public/graphics files
  - andrezzasouza/Millsberry-JS: matches Tyler tree shape (no additional SWF/PHTML signal)
  - karobelle/Millsberry-JS: matches Tyler tree shape (no additional SWF/PHTML signal)
  - naestech/millsberry: reduced tree (81 files), still no SWF/PHTML signal, includes same 44 public/graphics set
  - reddude256/Millsberry-JS: now 404 (unavailable)

### Secondary Repo Verification
- Artifact: recovery-osint/github_secondary_repo_tree_diff.json
- Findings:
  - Doctor-Android/PDMillsberry: effectively empty/public-domain stub (1 file)
  - Papaya12345/prayush: unrelated minimal repo (1 file)
  - nbrown1994/millsberry-remake: API returned 409 conflict (repo exists but no recoverable tree signal via this API call)

## Resolved Lead Status
- naestech/millsberry is now verified: useful Millsberry rewrite/Wayback artifact references, but no hidden SWF/PHTML payloads found.
- Other public millsberry-named repos checked in this pass do not currently add recoverable game binaries.

## Extraction Priority
1. TylerTheLoser/Millsberry-JS
   - Pull all graphics and visit_* artifacts
   - Parse embedded Wayback links and queue for recrawl
2. juvian/neopets-flash-fix
   - Reuse interception/routing methodology for Millsberry route simulations
3. Targeted repo-fork diffing on Millsberry-JS forks
   - Look for extra binary assets, old commits, and removed files
4. Commit-history and release-asset scrape (next)
  - Focus on deleted files, tags, and release uploads that may have contained binaries

## Immediate Next Probe Ideas
- GitHub commit-history scrape for graphics.millsberry.com references in Millsberry-JS forks
- GitHub code search for exact path fragments:
  - /site_gfx/maps/mainmap_
  - /game_interiors/interior_
  - /gamepages/flashgame_ctp.phtml
- Enumerate forks and search each fork specifically (owner/repo scoped)

## Breakthrough Update
- Historical GitHub extraction succeeded: 17 SWF files recovered from commit-pinned raw URLs.
- Recovery artifacts:
  - recovery-osint/github_fork_diff_findings_2026-06-04.md
  - recovery-osint/github-extracted-swfs/
  - recovery-osint/github_extracted_swf_manifest.json
- Hash-dedup correction:
  - recovery-osint/github_extracted_swf_hash_dedup_summary.json shows these 17 binaries already exist by content hash in official corpora.
  - Net-new value is provenance and reliable commit-pinned acquisition paths, not unique binary payload.
