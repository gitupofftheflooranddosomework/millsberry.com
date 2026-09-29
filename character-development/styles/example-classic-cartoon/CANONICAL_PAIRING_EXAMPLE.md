# Canonical Pairing Example

A style item is only one side of the system.

For example, this style contains:

```
items/hats/hat.blue_cap/style-item.json
```

That file answers:

> How does Classic Cartoon draw and position the Blue Cap?

The canonical catalog answers a different question:

> What is the Blue Cap in the game?

A real canonical definition would look broadly like this:

```json
{
  "id": "hat.blue_cap",
  "display_name": "Blue Cap",
  "category": "hat",
  "equip_slot": "headwear",
  "layer_group": "headwear",
  "supported_bodies": [
    "body.base_a",
    "body.base_b"
  ],
  "required_styles": [
    "style_a",
    "style_b"
  ],
  "release_state": "in_production",
  "provenance": "reborn_original",
  "notes": "Simple blue baseball-style cap."
}
```

The Classic Cartoon style implementation then contains only style-specific information:

```json
{
  "canonical_id": "hat.blue_cap",
  "style_id": "example_classic_cartoon",
  "anchors_used": [
    "head_center",
    "head_top"
  ],
  "layers": [
    {
      "layer": "headwear",
      "file": "hat.blue_cap.png"
    }
  ]
}
```

## Why this separation matters

The player's inventory should store:

```
hat.blue_cap
```

It should not store:

```
example_classic_cartoon_hat_blue_cap
```

That is what makes whole-avatar style switching possible without duplicating items, shops, rewards, or player ownership.
