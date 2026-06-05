# Millsberry Replay Archive

This repository preserves a recovered Millsberry replay stack, the supporting recovery notes, and the archived assets used to replay the site locally and on the public demo at `https://millsberry.markshaw.ca`.

## What Is Here

- `app/` - the replay server, Docker packaging, and local runtime assets.
- `official-core-recovered/`, `official-recovered/`, `official-recovered-assets/`, `official-full-backup/` - the recovered official source trees.
- `recovery-osint/` - route inventories, missing-asset reports, and recovery notes.
- `recovery-tools/` - tooling used during recovery.
- `another-user-backup-attempt/` - earlier backup material that is kept separate from the current recovery track.

## Public Demo

- URL: `https://millsberry.markshaw.ca`
- Demo login: `testcitizen` / `millsberry`

The public site is proxied through Apache to a localhost-only Node service so the replay backend is not directly exposed.

## Status

The replay is usable, but some recovered content is still incomplete. The best summary of what works and what is missing lives in `app/STATUS.md` and `app/ARCADE_RECOVERY.md`.

## Contributing

Pull requests that improve recovery coverage, verify missing assets, tighten route reconstruction, or improve documentation are welcome.

Before opening a PR, please read `CONTRIBUTING.md` and check `recovery-osint/missing-requests.jsonl` or `app/output/missing-requests.jsonl` for the highest-value gaps.

## Gallery

First-frame teaser photos extracted from recovered SWFs. The full interactive gallery (669 images, filterable and searchable) is at [`/swf-teasers`](https://millsberry.markshaw.ca/swf-teasers) on the live demo.

<table>
<tr>
<td align="center"><img src="app/public/teasers/swf/site_gfx/maps/mainmap_v30.webp" width="280" alt="Main Town Map v30"><br><sub>Main Town Map (v30)</sub></td>
<td align="center"><img src="app/public/teasers/swf/site_gfx/maps/mainmap_fall_v22.webp" width="280" alt="Main Town Map — Fall"><br><sub>Main Town Map — Fall Season</sub></td>
<td align="center"><img src="app/public/teasers/swf/games/discovered/downtown_v31.webp" width="280" alt="Downtown Map v31"><br><sub>Downtown Map (v31)</sub></td>
</tr>
<tr>
<td align="center"><img src="app/public/teasers/swf/site_gfx/interiors/int_goldenvalley_v8.webp" width="280" alt="Golden Valley Interior"><br><sub>Golden Valley</sub></td>
<td align="center"><img src="app/public/teasers/swf/site_gfx/interiors/int_basement_v1.webp" width="280" alt="Basement Interior"><br><sub>Basement</sub></td>
<td align="center"><img src="app/public/teasers/swf/site_gfx/interiors/int_park_v15.webp" width="280" alt="Park Interior"><br><sub>Peabody Park</sub></td>
</tr>
<tr>
<td align="center"><img src="app/public/teasers/swf/game_interiors/interior_180_v4.webp" width="280" alt="Galactic Swirl Defender Interior"><br><sub>Galactic Swirl Defender (interior)</sub></td>
<td align="center"><img src="app/public/teasers/swf/museum/paint_v4.webp" width="280" alt="Museum Paint"><br><sub>Museum</sub></td>
<td align="center"><img src="app/public/teasers/swf/contestPage.webp" width="280" alt="Contest Page"><br><sub>Contest Page</sub></td>
</tr>
</table>
