## Exports

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

exports.LGF_SpriteTextUI:handleTextUI(id, data)
```
