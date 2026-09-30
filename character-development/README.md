# Millsberry Reborn Character Development

This folder is the working home for all **new Millsberry Reborn character and avatar development**.

It is intentionally separate from recovered Millsberry assets. Nothing in this folder should be described as an original Millsberry asset unless its provenance has been independently verified and it has been moved into the appropriate recovered-assets area of the repository.

Start here:

- [CHARACTER_STANDARD.md](./CHARACTER_STANDARD.md) — the technical and production standard.
- [canonical/](./canonical/) — shared IDs and definitions that every art style implements.
- [styles/](./styles/) — one folder per supported visual style.
- [styles/example-classic-cartoon/](./styles/example-classic-cartoon/) — a completely filled-out, non-production worked example for artists and developers.
- [templates/](./templates/) — copyable manifests and artist handoff templates.
- [qa/](./qa/) — review checklists and release requirements.

## Core idea

Millsberry Reborn does not need one permanent avatar art style.

Instead, the project uses one shared character system with multiple complete visual interpretations. A canonical item such as `hat.blue_cap` exists once in inventory and game logic. Each supported style supplies its own artwork for that same item.

A player can therefore own one Blue Cap and render it in Chibi, Classic, or another supported style without owning separate copies.

The system standardizes **what an item is and how it behaves**. It does not force every artist to draw it with the same proportions, line work, or visual language.
