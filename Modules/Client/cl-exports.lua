---@diagnostic disable: undefined-doc-param, doc-field-no-class
---@class duiHandler
---@field duiObject any -- The DUI object that interacts with the UI

---@class TextUIData
---@field Visible boolean -- Whether the TextUI is visible or not
---@field Message string -- The message to be displayed
---@field Bind string? -- The key bind to be showed in the UI
---@field UseOnlyBind boolean? -- Whether to use only the bind key for interaction (default: false)
---@field CircleColor string? -- The color of the circle

-- Handle the TextUI creation or update
---@param id string|number -- Identifier for the TextUI
---@param data TextUIData -- Data containing the configuration for the TextUI
---@return duiHandler? -- The handler that interacts with the TextUI
exports("HandleTextUI", function(id, data)
    return TextUi:initializeDui(id, data)
end)

-- Clear all existing DUIs (is important to remove all dui existing on resource stop)
---@return nil
exports("RemoveTextUIs", function()
    return TextUi:clearAllDuis()
end)

-- Function to remove a specific DUI by its ID
---@param id string -- Unique identifier of the DUI to be removed
---@return nil
exports("RemoveTextUI", function(id)
    TextUi:removeDui(id)
end)

-- Function to render a 3D sprite ( requested to show the TextuUI sprite)
---@param data table -- Contains the DUI handler, coordinates (vector3), and max distance for rendering the sprite
---@field duiHandler duiHandler -- The DUI handler object (as defined above)
---@field coords vector3 -- Coordinates of the 3D sprite
---@field maxDistance number -- The maximum distance at which the sprite should be drawn
---@return nil
exports("Draw3DSprite", function(data)
    TextUi:render3DSprite(data.duiHandler, data.coords, data.maxDistance)
end)

-- Check if the TextUI is visible
---@return boolean -- Returns whether the TextUI is visible or not (based on LocalPlayer.state.TextUiBusy)
exports("IsDuiVisible", function()
    return LocalPlayer.state.TextUiBusy
end)
