# Contributing

Thanks for helping with the Millsberry replay archive.

## Good Contribution Targets

- Recovered assets that close known gaps.
- Better route reconstruction for missing pages and process endpoints.
- Verification against preserved captures or archived references.
- Documentation that explains recovery scope, limitations, and provenance.

## Before You Open a PR

- Avoid adding runtime state such as local account files or generated missing-request logs.
- Keep recovered data clearly separated from generated fallback files.
- Update the relevant notes in `app/STATUS.md` or `recovery-osint/` when behavior changes.
- If you add a new recovery source or a new fallback, say which one it is.

## Suggested Workflow

1. Find the missing route or asset in `app/output/missing-requests.jsonl` or `recovery-osint/`.
2. Recover or reconstruct the narrowest missing piece.
3. Verify the change in the replay app.
4. Update the status notes and open a PR with a short explanation of the gap it closes.
