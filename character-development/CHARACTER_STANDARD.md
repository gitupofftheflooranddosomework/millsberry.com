# Millsberry Reborn Character Development Standard

**Status:** Initial project standard  
**Applies to:** New Millsberry Reborn avatar bodies, faces, hair, clothing, accessories, wearable items, and future character style packs.

## 1. Purpose

Millsberry Reborn uses a shared avatar system that can support multiple complete art styles at the same time.

The project does **not** define "the Chibi Blue Cap" and "the Classic Blue Cap" as separate game items. It defines one canonical item, for example:

```
hat.blue_cap
```

Each active visual style then provides its own rendering of that item.

This lets us add new art directions without rebuilding player inventories, item ownership, shops, rewards, or save data. It also lets artists work in genuinely different visual styles without breaking compatibility with the rest of the game.

The standard is built around one rule:

> **Standardize the character system. Do not standardize the artist's drawing style.**

---

## 2. Terms

### Canonical item

The shared game definition of a body part, hairstyle, clothing item, or accessory.

Examples:

- `body.base_a`
- `hair.short_messy_01`
- `shirt.red_hoodie`
- `hat.blue_cap`

Canonical items own gameplay-facing information such as display name, category, equip slot, compatibility rules, and release state.

### Style pack

A complete visual interpretation of the canonical character catalog.

Examples may include:

- Chibi
- Classic Cartoon
- Storybook
- Retro

The actual names are chosen when styles are approved.

### Style asset

The artwork produced by a style for one canonical item.

For example:

```
canonical item: hat.blue_cap
style: chibi
asset: styles/chibi/items/hats/hat.blue_cap/
```

### Active style

A style currently supported for normal player use.

Active styles participate in the normal completion and release requirements.

### Incubating style

A proposed or incomplete style that is still being built. It does not block normal item releases until it is promoted to active.

This distinction is important. Adding a fifth experimental style must not freeze all character development while that artist catches up with years of existing items.

---

## 3. Character identity and body choices

Gameplay identity must be kept separate from the artwork used to display it.

The avatar system should not hard-code clothing to "male clothes" or "female clothes." Instead, a character selects from supported base body variants and equips compatible items.

Initial body work should include at least two baseline body presentations so the first style packs can cover the expected Millsberry character range. Working labels can be used during development, but canonical IDs should remain neutral and stable where practical.

Example:

```
body.base_a
body.base_b
```

A style may visually interpret those bases differently, but it must preserve the expected equipment anchors and compatible slots.

Future body variants can be added without replacing the original IDs.

---

## 4. Canonical catalog

Every item must receive a canonical ID before style-specific production begins.

Canonical IDs are permanent once released.

Recommended format:

```
<category>.<descriptive_name>
```

Examples:

```
body.base_a
body.base_b
hair.short_messy_01
hair.long_straight_01
eyes.round_01
mouth.smile_01
shirt.red_hoodie
pants.blue_jeans
shoes.white_sneakers
hat.blue_cap
glasses.round_black
accessory.backpack_green
```

Use lowercase letters, digits, underscores, and a single category separator.

Do not put the art style in a canonical ID.

Bad:

```
chibi_blue_cap
classic_blue_cap
```

Good:

```
hat.blue_cap
```

The style is a rendering choice, not part of item identity.

---

## 5. Required canonical item metadata

Each canonical item should define at minimum:

- `id`
- `display_name`
- `category`
- `equip_slot`
- `layer_group`
- `supported_bodies`
- `required_styles`
- `release_state`
- short design notes
- provenance classification
- optional original/reference material

Example:

```json
{
  "id": "hat.blue_cap",
  "display_name": "Blue Cap",
  "category": "hat",
  "equip_slot": "headwear",
  "layer_group": "hat",
  "supported_bodies": ["body.base_a", "body.base_b"],
  "required_styles": ["chibi", "classic"],
  "release_state": "in_production",
  "provenance": "reborn_original",
  "notes": "Simple blue baseball-style cap."
}
```

The canonical definition must not contain style-specific coordinates or artwork dimensions.

---

## 6. Style packs

Each style pack must have a stable `style_id`.

Example:

```
style_id: chibi
display_name: Chibi
```

A style pack owns:

- its own body proportions;
- its own canvas dimensions;
- its own anchors;
- its own line, shape, and shading language;
- its own item artwork;
- style-specific offsets where needed;
- style-specific clipping or masks;
- style-specific preview/reference sheets.

A style pack does **not** own separate game inventory.

A style is expected to render the same canonical items while remaining visually coherent with itself.

---

## 7. Art freedom versus technical compatibility

Artists are not required to use identical proportions.

A Chibi head may be much larger than a Classic head. A Storybook body may have longer legs. Hats and hair may therefore need different positions and silhouettes.

The common standard is semantic:

- this asset is a hat;
- this asset belongs to `hat.blue_cap`;
- this asset equips on the headwear slot;
- this asset follows the style's approved head anchor;
- this asset is rendered in the hat layer group.

The common standard is **not** "every cap must occupy the same pixels."

Every style defines its own geometry and anchor map.

---

## 8. Canvas and export rules

A style must declare one canonical working canvas size for normal avatar composition.

All assets within that style must be exported against that canvas unless a documented exception exists.

Recommended production requirements:

- PNG for raster production assets;
- transparent background;
- full style canvas retained on export;
- no manual cropping around individual items;
- lossless source file retained by the artist where practical;
- no baked-in background color;
- no unrelated body parts included in an item export;
- consistent scale within the style;
- consistent neutral avatar pose for normal wardrobe assets.

The renderer should be able to stack files without guessing their positions.

If vector source is used, the runtime/export format can still be PNG unless the client renderer later adopts vector assets.

---

## 9. Layer model

The exact implementation may evolve, but every style must map its artwork into the shared logical layer system.

Initial logical order, back to front:

1. `back_effect`
2. `hair_back`
3. `back_accessory`
4. `body`
5. `legs`
6. `feet`
7. `bottom`
8. `top`
9. `neck`
10. `face_base`
11. `eyes`
12. `mouth`
13. `face_detail`
14. `hair_front`
15. `glasses`
16. `headwear`
17. `front_accessory`
18. `front_effect`

An item can use more than one logical layer when necessary. For example, long hair may require both `hair_back` and `hair_front`.

Multi-layer items must declare all component files in their style manifest.

Do not solve a layering problem by baking unrelated clothing or body artwork into an item.

---

## 10. Equip slots

Canonical equip slots are gameplay rules and remain stable across styles.

Initial slots:

- `body`
- `eyes`
- `mouth`
- `hair`
- `top`
- `bottom`
- `shoes`
- `headwear`
- `glasses`
- `neck`
- `back_accessory`
- `hand_accessory`
- `special_accessory`

The implementation may add slots, but released slot names should not be casually renamed because player save data and item metadata may depend on them.

---

## 11. Anchors

Each style defines anchor points used to place or validate assets.

Expected anchors include:

- head center;
- head top;
- face center;
- neck;
- torso center;
- waist;
- left hand;
- right hand;
- left foot;
- right foot;
- back center.

These anchors belong to the style, not the canonical item.

An artist may adjust the geometry of the entire style without rewriting every canonical item definition as long as the style's assets and anchors stay internally compatible.

---

## 12. Base body requirements

A style cannot become active until its required base avatar set is complete.

At minimum an active style needs:

- all currently required base bodies;
- default eyes;
- default mouth;
- at least the minimum launch hair set;
- required starter clothing;
- required starter shoes;
- required shared anchors;
- an approved layer map;
- a working assembled reference character.

A style should first prove a complete dressed avatar before hundreds of individual items are assigned.

---

## 13. Style completeness

There are two different completeness concepts.

### Style launch completeness

Used when introducing a new style.

A new style begins as `incubating`. It becomes `active` only when it has completed the required baseline catalog and passes visual/technical review.

The baseline catalog is listed in `canonical/baseline-catalog.md`.

### Item release completeness

Used when introducing a new canonical item after multiple styles are active.

A normal canonical item is publishable only when every style listed in its `required_styles` has an approved implementation.

Example:

```
hat.blue_cap

chibi       approved
classic     approved
storybook   approved

release     ready
```

An incubating style is not automatically added to `required_styles`.

This prevents experimental styles from blocking the live catalog.

---

## 14. Release states

Canonical items use:

- `draft` — definition is still changing;
- `approved_for_art` — canonical design is stable enough for artists;
- `in_production` — one or more required style assets are being created;
- `qa` — required style assets exist and are being reviewed;
- `ready` — all release requirements pass;
- `released` — item is available in the game;
- `retired` — item remains known to the system but is no longer normally distributed.

Style implementations use:

- `not_started`;
- `in_progress`;
- `review`;
- `changes_requested`;
- `approved`.

Only `approved` satisfies an item release gate.

---

## 15. Artist workflow

For a new canonical item:

1. Create and approve the canonical item definition.
2. Confirm its equip slot, layer group, compatible bodies, and reference brief.
3. Add all active styles to `required_styles`.
4. Each style artist creates that style's interpretation.
5. Artist checks the asset on every required body.
6. Style asset moves to review.
7. Technical QA checks dimensions, transparency, naming, layers, and manifest.
8. Art review checks consistency with that style.
9. Approved style implementation is recorded.
10. When all required styles are approved, the canonical item may move to `ready`.
11. The item is published through the normal game release process.

Artists should not invent a new canonical ID merely because they want a different visual interpretation. If the gameplay item is the same item, it keeps the same ID.

---

## 16. Artist ownership

A style can have a lead artist without making the repository dependent on one person forever.

Each style manifest should record:

- style lead;
- contributors;
- review contact;
- style status.

Artwork should be reviewed against the style guide, not only against the original artist's personal preference.

If a style lead leaves, another contributor must be able to continue the style from the existing guide, source references, anchors, and approved assets.

---

## 17. Variants and recolors

A recolor may be implemented either as a separate canonical inventory item or as a controlled variant.

The choice depends on gameplay.

If players can independently own or trade the colors, they should normally be separate canonical IDs:

```
hat.cap_blue
hat.cap_red
```

If color is simply a renderer customization and not a distinct inventory object, one canonical item may declare supported color variants.

Do not hide gameplay-significant variants only inside filenames.

---

## 18. Multi-part assets

Some items naturally cross multiple layers.

Examples:

- long hair;
- capes;
- jackets that cover both torso and arms;
- handheld props;
- large hats overlapping hair;
- costumes replacing several normal slots.

These items should use an item manifest declaring their component files and any slot conflicts.

Do not flatten an entire avatar into one image for convenience.

---

## 19. Compatibility and clipping

Every style asset must be reviewed against all base bodies it claims to support.

Known intentional incompatibilities are allowed but must be explicit.

Example:

```
supported_bodies:
  - body.base_a

unsupported_bodies:
  - body.base_b
```

The preferred direction is broad compatibility. Exceptions should exist because of an actual design limitation, not because an artist did not test the second body.

---

## 20. Player style selection

The normal player-facing model should be:

```
avatar_style = chibi
equipped_hat = hat.blue_cap
```

not:

```
equipped_hat = chibi_blue_cap
```

Changing avatar style should attempt to redraw the player's current canonical equipment in the newly selected style.

This is one of the main reasons the canonical catalog exists.

A future experimental "mix styles" mode may be possible, but it should not shape the initial data model. The default system assumes one selected style for the complete avatar.

---

## 21. Missing style assets at runtime

Released items should not normally reach production with a missing required style asset.

The renderer must still fail safely.

If a valid canonical item is equipped but its selected style asset is unexpectedly missing:

1. do not corrupt or remove the player's owned item;
2. log the missing mapping;
3. use an approved placeholder or omit that visual layer;
4. never silently substitute another item;
5. surface the failure in development/QA reporting.

Inventory identity must survive rendering failures.

---

## 22. Provenance

This project contains recovered Millsberry material as well as new Millsberry Reborn work. They must remain distinguishable.

Every canonical definition and art contribution must use one of these provenance classes:

- `recovered_original` — verified original material;
- `reconstructed_from_reference` — newly drawn or rebuilt from preserved reference material;
- `reborn_original` — new work designed for Millsberry Reborn;
- `unknown` — temporary classification that must be resolved before release.

Newly drawn style-pack artwork is not a recovered original even when it recreates an old Millsberry item.

Reference images should be stored or linked separately from production output so the provenance remains clear.

---

## 23. File naming

Canonical IDs use periods as category separators.

Artwork filenames use the canonical ID plus a layer suffix where needed.

Examples:

```
hat.blue_cap.png
hair.long_straight_01.back.png
hair.long_straight_01.front.png
```

Avoid:

- spaces;
- artist names in runtime filenames;
- version numbers such as `final2`;
- vague filenames such as `shirt1.png`;
- style names inside files already contained by a style directory.

Version history belongs in Git.

---

## 24. Directory standard

```
character-development/
  canonical/
    items/
    baseline-catalog.md

  styles/
    _template/
    chibi/
      STYLE.md
      style.json
      bodies/
      items/
        hair/
        tops/
        bottoms/
        shoes/
        hats/
        glasses/
        accessories/

  templates/
    canonical-item.json
    style.json
    style-item.json

  qa/
    ART_REVIEW.md
    TECHNICAL_REVIEW.md
```

Git does not preserve empty directories, so folder scaffolding can use README or `.gitkeep` files until real content is added.

---

## 25. Source files and runtime exports

Artists should retain editable source files whenever possible.

Runtime exports and editable sources should not be mixed indiscriminately.

A style may use:

```
styles/chibi/source/
styles/chibi/export/
```

if source files will live in Git.

If source files are too large or unsuitable for the repository, the style README must document where the authoritative editable source is maintained.

Runtime builds must never depend on a private workstation-only source path.

---

## 26. QA: technical review

Technical review checks:

- correct canonical ID;
- correct directory;
- valid manifest;
- correct file type;
- transparent background;
- expected canvas size;
- correct layer mapping;
- no unintended cropping;
- no unrelated baked-in artwork;
- all declared files exist;
- all required bodies tested;
- no obvious clipping at normal pose;
- no filename collisions;
- provenance recorded.

---

## 27. QA: art review

Art review checks:

- asset clearly represents the canonical item;
- item is recognizable across styles;
- asset belongs visually to its selected style;
- scale feels correct for that style;
- pose and silhouette remain readable;
- body coverage and overlap look intentional;
- line/shading/detail level matches existing approved work;
- no avoidable clipping with hair, hats, face, or clothing;
- asset does not accidentally redefine the canonical design.

Different styles do not need to match stroke-for-stroke.

They do need to feel like interpretations of the same item.

---

## 28. Changing a released canonical item

Released IDs are stable.

If an item's art needs improvement, replace or revise the style asset under the same canonical ID.

If the gameplay identity changes substantially enough that old players should keep the old version, create a new canonical item.

Never reuse an old canonical ID for an unrelated object.

---

## 29. Retiring a style

A style should not simply disappear from the filesystem after players have used it.

If a style is retired:

- mark the style `retired`;
- preserve its mapping for existing released items;
- prevent new selection if appropriate;
- define how saved avatars using the style are handled;
- do not change player inventory IDs.

Style lifecycle and inventory lifecycle are separate.

---

## 30. Adding a new style later

New styles are expected.

The process is:

1. create a new style folder from `styles/_template`;
2. assign a stable `style_id`;
3. write the style guide;
4. define canvas and anchors;
5. create all required base bodies;
6. complete the current baseline catalog;
7. pass art and technical QA;
8. mark the style active;
9. add it to `required_styles` for new items going forward.

Whether an older item must be backfilled before a new style can launch is a production decision, but the style must never advertise an item mapping it does not actually have.

---

## 31. Automation target

The folder layout and manifests are intentionally machine-readable.

Future repository checks should be able to answer:

- Which canonical items exist?
- Which styles are active?
- Which required style implementations are missing?
- Which files referenced by manifests do not exist?
- Which items are blocked from release?
- Which style has the largest backlog?
- Are IDs duplicated?
- Are runtime dimensions valid?

The long-term goal is a completion matrix generated from source metadata rather than maintained manually.

Example:

```
                    Chibi   Classic   Storybook   Release
hat.blue_cap          ✓        ✓          ✓          ready
shirt.red_hoodie      ✓        ✓          -          blocked
pants.blue_jeans      ✓        ✓          ✓          ready
```

---

## 32. Decision rule

When there is uncertainty, ask two questions:

1. **Is this describing the gameplay identity of the item?**  
   Put it in the canonical catalog.

2. **Is this describing how one art style draws or positions the item?**  
   Put it in the style pack.

Keeping that boundary clean is the foundation of the entire system.
