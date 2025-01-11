![GitHub Downloads](https://img.shields.io/github/downloads/ENT510/LGF_SpriteTextUI/total?logo=github)
![GitHub Release](https://img.shields.io/github/v/release/ENT510/LGF_SpriteTextUI?logo=github)

# LGF TEXTUI SPRITE

[Prewiev TextUI](https://streamable.com/dvk641)

## NO HOLDING

### Create and configure TextUI/DUI

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

### Close Only TextUI/DUI

```lua
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports.LGF_SpriteTextUI:CloseTextUI(id)
```

### Remove TextUI/DUI from ID

```lua
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports.LGF_SpriteTextUI:RemoveTextUI(id)
```

### Remove all Existing TextUIs/DUIs

```lua
---@return nil
exports.LGF_SpriteTextUI:RemoveTextUIs()
```

### Render a 3Dsprite with correct properties (required 0 thick)

```lua
---@param data table -- Contains the DUI handler, coordinates (vector3), and max distance for rendering the sprite
---@field duiHandler duiHandler -- The DUI handler object (as defined above)
---@field coords vector3 -- Coordinates of the 3D sprite
---@field maxDistance number -- The maximum distance at which the sprite should be drawn
---@return nil
exports.LGF_SpriteTextUI:Render3DSprite(data)
```

### Get The visibility state of the TextUI/DUI

```lua
---@return boolean -- Returns whether the TextUI is visible or not (based on LocalPlayer.state.TextUiBusy)
exports.LGF_SpriteTextUI:IsDuiVisible()
```

## HOLDING

### Create and configure TextUI/DUI using the holder state

```lua
---@class TextUIData
---@field Visible boolean -- Whether the TextUI is visible or not
---@field Message string -- The message to be displayed
---@field Bind string? -- The key bind to be showed in the UI
---@field UseOnlyBind boolean? -- Whether to use only the bind key for interaction (default: false)
---@field CircleColor string? -- The color of the circle

---@class HoldInteractionData : TextUIData
---@field BindToHold number -- The control ID for holding the key (default 38 for 'E')
---@field TimeToHold number -- The amount of time (in seconds) the key should be held (default 5)
---@field DistanceHold number -- The distance within which the interaction is valid (default 2)
---@field Coords vector3 -- Coordinates of the interaction point (x, y, z) (used to check the distance for enable The holding)
---@field onCallback fun(id: string|number) -- Callback function to be called when interaction is complete
---@field canInteract fun(id: string|number, distance: number): boolean -- Callback function to determine if interaction is possible
exports.LGF_SpriteTextUI:HandleHoldTextUI(id, data)
```

### Remove TextUI/DUI from ID using the holder state

```lua
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports.LGF_SpriteTextUI:RemoveHoldTextUI(id)
```

### Remove all Existing TextUIs/DUIs using the holder state

```lua
---@return nil
exports.LGF_SpriteTextUI:RemoveHoldTextUIs()
```

### Close Only TextUI/DUI state using the holder state

```lua
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports.LGF_SpriteTextUI:CloseHoldTextUI(id)
```

# Example Usage Without HOLDER

```lua
local DuiHandler = exports.LGF_SpriteTextUI:HandleTextUI("id_without_hold", {
    Visible = true,
    Message = "Press to interact",
    Bind = 'E',
    UseOnlyBind = false,
    CircleColor = "teal",
})
```

# Example Usage With HOLDER

```lua
local DuiHandler = exports.LGF_SpriteTextUI:HandleHoldTextUI("id_hold", {
    Visible = true,
    Message = 'Hold to interact',
    Bind = "E",
    CircleColor = "teal",
    UseOnlyBind = false,
    BindToHold = 38,
    TimeToHold = 5,
    DistanceHold = 2,
    Coords = GetEntityCoords(cache.ped),
    canInteract = function(id,distance)
        return true
    end,
    onCallback = function(id)
        exports.LGF_SpriteTextUI:RemoveHoldTextUI(id)
    end
})
```
