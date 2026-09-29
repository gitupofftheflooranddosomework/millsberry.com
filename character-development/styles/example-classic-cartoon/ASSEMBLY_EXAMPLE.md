# Assembly Example

This file shows how one player's canonical equipment would be interpreted by this style.

## Player state

```json
{
  "avatar_style": "example_classic_cartoon",
  "body": "body.base_a",
  "hair": "hair.short_messy_01",
  "top": "shirt.red_hoodie",
  "bottom": "pants.blue_jeans",
  "shoes": "shoes.white_sneakers",
  "headwear": "hat.blue_cap",
  "glasses": "glasses.round_black",
  "back_accessory": "accessory.backpack_green"
}
```

## Logical draw order

```
accessory.backpack_green       -> back_accessory
hair.short_messy_01            -> hair_back
body.base_a                    -> body
pants.blue_jeans               -> bottom
shirt.red_hoodie               -> top
shoes.white_sneakers           -> feet
hair.short_messy_01            -> hair_front
glasses.round_black            -> glasses
hat.blue_cap                   -> headwear
```

The renderer does not change the canonical IDs when the player selects another style. It resolves the same IDs through that style's item manifests.
