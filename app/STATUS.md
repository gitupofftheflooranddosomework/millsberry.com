# Millsberry Replay Status

Last updated: 2026-06-05

## Current Runtime

- App path: `app/`
- Runtime: Docker Compose service `millsberry`
- URL: `http://localhost:3000`
- Last verified index counts: 2,187 exact routes, 1,484 assets, 1,670 page files, and 1,465 recovered shop items
- Data mounts:
  - `official-core-recovered`
  - `official-recovered`
  - `official-recovered-assets`
  - `official-full-backup`
  - `recovery-osint`

## What Works Now

- The app starts in Docker and serves the replay launcher.
- Official recovered routes are indexed from the targeted manifest.
- Extra official pages are inferred from `official-full-backup`.
- Official SWF, image, CSS, JS, PDF, XML, and Unity3D assets are served from recovered host trees.
- Local replay asset requests default to the matching official host before broad path/name fallbacks, which keeps older page captures paired with their correct recovered CSS when available.
- HTML pages are rewritten so old Millsberry absolute URLs point back to the local replay server.
- Encoded Flash parameter URLs are rewritten so Ruffle/SWF loaders request local assets.
- Ruffle injection is controlled by `RUFFLE_URL`; it can use the current CDN default, a local hosted copy, or be disabled with `RUFFLE_URL=0`.
- Known absent legacy side-nav PNGs receive generated 130x35 button fallbacks so recovered navigation remains visible.
- Missing decorative image files receive a transparent 1x1 fallback to preserve page layout.
- Missing route and asset requests are tracked at `/__missing` and `/__missing.json`.
- Missing requests are appended to `app/output/missing-requests.jsonl` from the Docker container.
- Persistent local signup, login, session, logout, account, citizen home, and archival citizen profile behavior.
- Recovered shop forms purchase indexed official items with persistent Millsbucks and inventory quantities.
- Wallet and bank balances support persistent deposits and withdrawals.
- The main map has responsive City, Downtown, Lakeview, Golden Valley, and Metro Park views, working HTML destinations, and optional loading of the recovered official SWFs.
- Buddy lists and page shortcuts persist per account; buddy XML reflects the signed-in account.
- Common unreconstructed dynamic endpoints still have explicit local stubs.

## Verified Routes

- `/`
- `/__official-root`
- `/gamepages/games_list.phtml`
- `/gamepages/hiscores.phtml?game_id=420`
- `/__account`
- `/home/?user=testcitizen`
- `/inventory.phtml`
- `/bank/`
- `/main_map.phtml`
- `/main_map.phtml?location=downtown`
- `/main_map.phtml?location=lakeview`
- `/main_map.phtml?location=goldenvalley`
- `/main_map.phtml?location=metropark`
- `/buddies.phtml`
- `/shortcuts.phtml`
- `/activities/batmanfru/batman.phtml`
- `/site_gfx/sideNavButton_v2.swf`
- `/top_nav_xml.phtml`
- `/side_nav_xml.phtml`
- `/load_buddy_xml.phtml`
- `/process_shortcut.phtml?action=add&url=/gamepages/hiscores.phtml?game_id=420&name=Hi%20Scores`
- `/process_shop.phtml` using official item `1765`
- `/process_bank.phtml` deposit and withdrawal
- `/process_buddy_list.phtml`
- `/process_break_time.phtml?choice=1&redirect=%2Fbank%2F`
- `npm run crawl`: 211 representative requests, 0 hard 404 failures
- `npm run test:auth`: 8 checks passed
- `npm run test:economy`: 19 checks passed
- Browser screenshots: `verified-hiscores.png`, `verified-authenticated-hiscores.png`, `verified-inventory.png`, `verified-shortcuts.png`, and `verified-main-map.png` in `app/output/`.

## Known Gaps

- Some referenced SWFs are not present in the recovered official folders, including early `stat_icon_*.swf` files, `prebuddy.swf`, and many individual item artwork SWFs.
- Some nav PNGs and `/css/gamepages/hiscores.css` are served by explicit generated replay fallbacks because no official recovered file has been found for those exact paths.
- Game score submission, avatar customization, home furnishing, post office messaging, and several event-specific process endpoints still need reconstruction.
- Modern browsers require Ruffle or another Flash-compatible runtime for SWF content; not all old ActionScript behavior is guaranteed to work.

## Next Recovery Work

- Use `app/output/missing-requests.jsonl` to prioritize the next missing asset recovery pass.
- Replace process stubs with better reconstructed behavior where page captures and SWF parameters reveal expected response formats.
- Add route grouping by area/game/year in the launcher.
- Search non-official fallback sources only when an official asset is absent and clearly mark those files as fallback.
