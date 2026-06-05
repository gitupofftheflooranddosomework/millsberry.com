# Millsberry Replay Archive

This is a Dockerized replay of recovered Millsberry pages, assets, and launcher logic. It is meant to be easy to launch locally, easy to inspect publicly, and explicit about what is still missing.

## What You Can Publish

The pieces that are reasonable to host publicly are the replay application, Docker packaging, recovery manifests, missing-asset tracking, and the vendored Ruffle runtime.

The parts that deserve a separate review before publishing are the recovered page and asset trees, the runtime account store, generated logs, and any files you do not want to keep under version control.

## Quick Start

```powershell
cd app
docker compose up --build
```

Open `http://localhost:3000`.

Public demo URL:

```text
https://millsberry.markshaw.ca
```

The container seeds a local demo account for convenience:

```text
Username: testcitizen
Password: millsberry
```

If you want to point at a different Ruffle build, set `RUFFLE_URL` in the environment. Set `RUFFLE_URL=0` to disable injection entirely.

The public deployment should run the container on localhost only and expose it through the `millsberry.markshaw.ca` Apache vhost, so the backend is not directly reachable from the public network.

## What It Does

- Maps archived Millsberry routes from `recovery-osint/official_core_pages_manifest.json`.
- Serves recovered official page captures from `official-core-recovered`, `official-recovered`, and `official-full-backup`.
- Serves recovered official assets from `official-recovered-assets` and `official-full-backup`, including SWF navigation and game files.
- Rewrites historical Millsberry host URLs back to local replay URLs.
- Prefers the matching official-host asset first, then falls back to broader path and filename matches.
- Injects vendored Ruffle so recovered SWF embeds can run in modern browsers without an external dependency.
- Keeps the replay launcher at `/`; the recovered official root capture is available at `/__official-root`.
- Tracks missing or generated fallback responses at `/__missing` and `/__missing.json`.
- Persists local accounts and sessions in `app/data/accounts.json`.
- Supports signup, login, logout, citizen homes, Millsbucks, recovered shop purchases, inventory, banking, buddies, and page shortcuts.
- Indexes recovered shop captures into a catalog instead of hardcoding individual products.

Modern browser support for old Flash content is still imperfect. The SWFs are served locally, but some games and page behaviors still depend on browser or Flash-era behavior that Ruffle does not fully reproduce.

## Launch Checks

With the Docker app running:

```powershell
cd app
npm run test:auth
npm run test:economy
npm run crawl
```

The crawler requests representative recovered routes and local references, then records missing items through `/__missing` so the remaining gaps stay visible.

## Current Verified State

The Docker app currently indexes 2,187 exact routes, 1,484 recovered assets, 1,670 page files, and 1,465 recovered shop items.

Verified routes include:

- `/`
- `/__official-root`
- `/gamepages/games_list.phtml`
- `/gamepages/hiscores.phtml?game_id=420`
- `/__account`
- `/inventory.phtml`
- `/bank/`
- `/main_map.phtml` with City, Downtown, Lakeview, Golden Valley, and Metro Park views
- `/buddies.phtml`
- `/shortcuts.phtml`
- `/activities/batmanfru/batman.phtml`
- `/site_gfx/sideNavButton_v2.swf`
- Representative crawl via `npm run crawl`: 211 requests, 0 hard 404 failures after current fallbacks and placeholders.
- Browser-verified screenshots in `app/output/` for hi scores, authenticated hi scores, inventory, shortcuts, main map, and arcade recovery work.

## Known Gaps

- Some decorative assets are still missing from the recovered official sources, including `stat_icon_*.swf` files and individual item artwork SWFs referenced by shop loaders.
- Some nav PNGs and `/css/gamepages/hiscores.css` still use explicit generated replay fallbacks because the original files have not been recovered.
- Several unreconstructed dynamic endpoints still need better behavior, including score submission, avatar customization, home furnishing, post office messaging, and event-specific process endpoints.
- Some older SWF titles still stall or diverge inside Ruffle even when the binaries are present.
- Public hosting should treat the recovered content as archival material and keep any files you do not want to expose separated from the code-only replay app.

## How To Help

This project is most useful when people help close recovery gaps instead of only mirroring what already works.

Useful contributions include:

- Matching missing assets from archive captures, browser caches, or other preserved copies.
- Verifying SWF startup and gameplay behavior in Ruffle against preserved pages.
- Reconstructing missing process endpoints from page captures and request patterns.
- Expanding the missing-request report with clearer provenance for each unresolved path.
- Testing the replay against different browsers and Ruffle builds.

The fastest place to start is `/__missing.json`, plus the recovery notes under `STATUS.md` and `ARCADE_RECOVERY.md`.
