# Navigation artwork

The 2010 site chrome, rendered out of the recovered navigation movies rather
than drawn. Every file here is a derivative of an official recovered asset;
none of it is original work, and none of it is a reconstruction.

| File | Source | What it is |
|---|---|---|
| `top_button.png` | `graphics.millsberry.com/site_gfx/top_nav_v2.swf` — `DefineSprite_16_iconbutton` | The top-bar pill, 117x32, rendered without its "BUTTON" placeholder text field. |
| `side_button.png` | `graphics.millsberry.com/site_gfx/side_nav_v3.swf` — `DefineSprite_31_iconbutton` | The badged side-nav button (Sign Out), 119x32. |
| `side_bar.png` | `side_nav_v3.swf` — `DefineSprite_36_button` | The plain side-nav destination bar, 151x29. |
| `name_plate.png` | `side_nav_v3.swf` — `DefineSprite_44_header` | The yellow leaning plate the Buddy's name sits on, 150x51. |
| `section_plate.png` | `side_nav_v3.swf` — `DefineSprite_40_header_blue` | The pale blue section plate ("Find a Buddy", "Hot Spots"), 151x27. |
| `*_hover.png` | the three sprites above | The hover state: the flat `#004AD5` face remapped to `#FFFA35` along the outline→face axis, so the navy outline and its anti-aliased edge are kept. A derivation, not a recovered frame — the movies fetched their button states at runtime. |
| `stat_fit_v1.png` … `stat_hun_v1.png` | `graphics.millsberry.com/site_gfx/stat_*_v1.gif` | The five stat icons. The originals are one-bit GIFs matted against white; these have the white outline flooded away so they sit on the blue column. |
| `buy_icon.png` | `graphics.millsberry.com/site_gfx/buy_icon.gif` | The Millsbucks note, same cleanup. |
| `loading_m.png` | `graphics.millsberry.com/locations/loader.swf` | The M every movie loaded behind, rendered from the loader's sprite (the movie renders blank as a frame). `public/loader.js` paints it over Ruffle's splash screen. |

The GIF originals are already in the recovered trees and are served at their
original paths (`/site_gfx/stat_fit_v1.gif` etc.). The logo the shell uses is
served straight from the recovered tree: `/site_gfx/layout/title_logo.png`.

## Typefaces (`fonts/`)

| File | Source | What it is |
|---|---|---|
| `cheeseburger.woff2` | `top_nav_v2.swf` — its `iconButtonFont` export | Cheeseburger (Fontalicious, 2002), the top-bar pills. |
| `huggable.woff2` | `side_nav_v3.swf` — its `iconButtonFont` export | Fontdinerdotcom Huggable (Font Diner), the side-nav buttons, plates and headings. |

The movies embed their faces as `DefineFont3` glyph outlines, so JPEXS
reconstructs a TTF from them; these are whole fonts (Cheeseburger carries 243
mapped characters and its own copyright string), converted to woff2. Kerning
does not survive the round trip; advance widths do. Both faces draw lowercase
as small capitals, which is where the site's small-caps look came from — the
shell must not add `font-variant: small-caps` on top.

Note that both are **commercial faces belonging to other rights holders**,
carried inside the recovered movies. They are not General Mills artwork.

The badge icons inside the top-bar pills are the one invented part: the
movies fetched each destination's icon at runtime from a URL in an XML feed,
so they were never inside the SWFs and are not recovered. The shell draws a
plain Unicode mark in the empty badge instead.
