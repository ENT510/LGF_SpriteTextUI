# LGF TEXTUI SPRITE

[Prewiev TextUI](https://streamable.com/dvk641)

## Create and configure TextUI/DUI

```lua
---@class TextUIData
---@field Visible boolean -- Whether the TextUI is visible or not
---@field Message string -- The message to be displayed
---@field Bind string? -- The key bind to be showed in the UI
---@field UseOnlyBind boolean? -- Whether to use only the bind key for interaction (default: false)
---@field CircleColor string? -- The color of the circle

---@param id string|number -- Identifier for the TextUI
---@param data TextUIData -- Data containing the configuration for the TextUI
---@return duiHandler? -- The handler that interacts with the TextUI

exports.LGF_SpriteTextUI:HandleTextUI(id, data)
```

## Remove TextUI/DUI from ID

```lua
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports.LGF_SpriteTextUI:RemoveTextUI(id)
```

## Remove all Existing TextUIs/DUIs

```lua
---@return nil
exports.LGF_SpriteTextUI:RemoveTextUIs()
```

## Render a 3Dsprite with correct properties (required 0 thick)

```lua
---@param data table -- Contains the DUI handler, coordinates (vector3), and max distance for rendering the sprite
---@field duiHandler duiHandler -- The DUI handler object (as defined above)
---@field coords vector3 -- Coordinates of the 3D sprite
---@field maxDistance number -- The maximum distance at which the sprite should be drawn
---@return nil
exports.LGF_SpriteTextUI:Render3DSprite(data)
```

## Get The visibility state of the TextUI/DUI

```lua
---@return boolean -- Returns whether the TextUI is visible or not (based on LocalPlayer.state.TextUiBusy)
exports.LGF_SpriteTextUI:IsDuiVisible()
```
