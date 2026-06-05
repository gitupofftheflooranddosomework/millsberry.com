# Local Corpus Route Discovery (2026-06-04)

## Scope
Extract explicit game route IDs from local corpus references to:
- /gamepages/flashgame_ctp.phtml?game_id=...
- /gamepages/hiscore.phtml?game_id=...

## Method Notes
Two passes were run:
1. Broad scan including recovery-osint (contaminated by generated candidate files).
2. Clean scan excluding recovery-osint (corpus-only result).

## Results
### Pass 1 (includes generated artifacts)
- Discovered IDs: 578
- This is contaminated because generated candidate files include mass synthetic IDs.

Artifacts:
- recovery-osint/local_discovered_game_ids.txt
- recovery-osint/local_discovered_game_ids_extra_over_candidates.txt

### Pass 2 (clean, no generated artifacts)
- Discovered IDs: 5
- IDs: 12, 13, 16, 80, 180

Artifact:
- recovery-osint/local_discovered_game_ids_no_generated.txt

## Conclusion
- Local corpus route evidence (without generated artifacts) currently confirms only a small subset of game IDs.
- Candidate expansion for missing games still relies mainly on synthetic enumeration + external validation, not abundant in-corpus route references.
