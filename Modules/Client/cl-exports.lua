---@diagnostic disable: undefined-doc-param, doc-field-no-class

---@class duiHandler
---@field duiObject any -- The DUI object that interacts with the UI

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
---@field Coords vector3 -- Coordinates of the interaction point (x, y, z)
---@field onCallback fun(id: string|number) -- Callback function to be called when interaction is complete
---@field canInteract fun(id: string|number, distance: number): boolean -- Callback function to determine if interaction is possible

-- Handle the TextUI creation or update
---@param id string|number -- Identifier for the TextUI
---@param data TextUIData -- Data containing the configuration for the TextUI
---@return duiHandler? -- The handler that interacts with the TextUI
exports("HandleTextUI", function(id, data)
    return TextUi:initializeDui(id, data)
end)

-- Close TextUI based on ID
---@param id string|number -- Identifier for the TextUI
---@return nil
exports("CloseTextUI", function(id)
    return TextUi:close(id)
end)

-- Clear all existing DUIs (is important to remove all dui existing on resource stop)
---@return nil
exports("RemoveTextUIs", function()
    return TextUi:clearAllDuis()
end)

-- Function to remove a specific DUI by its ID
---@param id string|number -- Unique identifier of the DUI to be removed
---@return nil
exports("RemoveTextUI", function(id)
    TextUi:removeDui(id)
end)

-- Function to render a 3D sprite (requested to show the TextUI sprite)
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

-- Handle the Hold interaction for a specific ID
---@param id string|number -- Unique identifier of the Hold interaction
---@param data HoldInteractionData -- Data for the Hold interaction (includes all TextUIData fields)
---@return duiHandler? -- The DUI handler associated with the Hold interaction
exports("HandleHoldTextUI", function(id, data)
    return Hold:init(id, data)
end)

-- Remove all active Hold interactions
---@return nil
exports("RemoveHoldTextUIs", function()
    for id, _ in pairs(Hold.instances) do
        Hold:remove(id)
    end
end)

-- Remove a specific Hold interaction by ID
---@param id string|number -- Unique identifier of the Hold interaction
---@return nil
exports("RemoveHoldTextUI", function(id)
    Hold:remove(id)
end)

-- Close only The Ui/dui state
---@param id string|number -- Unique identifier of the Hold interaction
---@return nil
exports("CloseHoldTextUI", function(id)
    Hold:closeDui(id)
end)
