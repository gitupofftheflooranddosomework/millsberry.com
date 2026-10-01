# Classic Cartoon — Worked Example

**Style ID:** `example_classic_cartoon`  
**Status:** incubating  
**Documentation only:** yes  
**Lead artist:** example/unassigned

## Visual direction

A clean, friendly web-cartoon style intended to read clearly at small avatar sizes.

Characters use simplified anatomy, rounded forms, clear silhouettes, medium-weight outlines, and limited shading. The proportions are stylized without becoming super-deformed: the head is larger than realistic anatomy, but the torso and legs still read as a conventional standing character.

This example is intentionally generic. It exists to demonstrate how a style should be documented, not to define the final Millsberry Reborn look.

## Proportions

- Working canvas: 1024 × 1024.
- Ground line: y = 930.
- Approximate standing character height: 835 px.
- Head occupies roughly 30–33% of visible character height.
- Hands are simplified and slightly oversized for readability.
- Feet are wide enough for shoes to remain readable when the avatar is scaled down.
- Body A is slightly narrower through the shoulders and hips.
- Body B is slightly broader through the shoulders and torso.
- Both bodies use the same logical anchor names.

## Pose

Neutral standing pose:

- body faces forward;
- shoulders level;
- arms rest slightly away from torso;
- hands remain visible;
- feet point mostly forward;
- no strong perspective tilt;
- no pose-specific clothing distortion.

Wardrobe items are authored for this pose unless a future animation/pose system explicitly says otherwise.

## Canvas

- Width: 1024
- Height: 1024
- Origin: top-left
- Ground line: y = 930
- Character center line: x = 512
- Transparent background required for production exports

Do not tightly crop individual assets. Items are positioned on the full style canvas so stacking does not require per-file guesswork.

## Line treatment

- Medium-weight outer contour.
- Slightly lighter internal detail lines.
- Rounded joins where practical.
- Avoid scratchy or highly textured outlines.
- Detail should survive reduction to normal in-game avatar size.

## Shading

- Primarily flat local color.
- One simple shadow family when needed.
- One small highlight family when needed.
- Avoid realistic rendering or complex gradients unless the style is intentionally revised later.

## Color

Canonical colors should remain recognizable, but the artist may shift values slightly to keep the full style cohesive.

For example, "blue" does not require one exact RGB value across every style. It should still read unambiguously as the intended blue item.

## Face

- Eyes remain clearly separated and readable.
- Mouth shapes are simple.
- Nose detail is optional/minimal.
- Glasses use the face-center anchor and must not be baked into eyes.
- Hair must not contain face features.

## Hair

Hair may use two layers:

- `hair_back`
- `hair_front`

Headwear is rendered after `hair_front`. Hair variants that need a special hat-compatible version should document that requirement rather than silently clipping.

## Clothing fit

### Tops
Tops align to the neck and torso-center anchors and normally terminate around the waist.

### Bottoms
Bottoms align to the waist anchor and must remain compatible with the shoe/foot region.

### Shoes
Shoes use the left-foot and right-foot anchors. A single pair may be represented by one canvas-sized export or two declared component layers.

### Hats
Headwear uses `head_top` and `head_center`. The cap brim may overlap the forehead/hair but must not permanently erase face layers.

### Back accessories
Back accessories render behind the body and align primarily to `back_center`.

## Silhouette rule

At normal display size, an item should still be identifiable by shape before relying on tiny surface details.

## Continuity rule

If another artist continues this style, they should match the approved style references and this guide rather than trying to imitate the previous artist's file-by-file quirks.
