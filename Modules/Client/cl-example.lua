local Config = require "Modules.Client.cl-config"
if not Config.EnableDebug then return end
Pumps = {}


local pumpModels = {
    { model = "prop_gas_pump_1a", coords = vector3(-66.9443, 6544.8960, 30.4908) },
    { model = "prop_gas_pump_1a", coords = vector3(-60.2241, 6539.8809, 30.4908) },
    { model = "prop_gas_pump_1a", coords = vector3(-52.0387, 6542.6284, 30.4909) },
}

CreateThread(function()
    Wait(2000)
    local duiHandlers = {}

    for I = 1, #pumpModels do
        local model = lib.requestModel(pumpModels[I].model)
        if not model then return end
        local pumpEntity = CreateObject(model, pumpModels[I].coords.x, pumpModels[I].coords.y, pumpModels[I].coords.z,
            true, true, true)
        Pumps[#Pumps + 1] = pumpEntity

        local point = lib.points.new({
            coords = pumpModels[I].coords,
            distance = 2,
        })

        function point:onEnter()
            duiHandlers[self.id] = exports.LGF_SpriteTextUI:handleTextUI(self.id, {
                Visible = true,
                Message = ('Interact With Pump %s'):format(self.id),
                Bind = 'E',
                UseOnlyBind = false,
                CircleColor = "orange"
            })
            self.duiHandler = duiHandlers[self.id]
        end

        function point:onExit()
            exports.LGF_SpriteTextUI:handleTextUI(self.id, {
                Visible = false,
                Message = ('Interact With Pump %s'):format(self.id),
                Bind = 'E',
                UseOnlyBind = false,
                CircleColor = "orange"
            })
            duiHandlers[self.id] = nil
        end

        function point:nearby()
            exports.LGF_SpriteTextUI:draw3DSprite({
                duiHandler = self.duiHandler,
                coords = vec3(self.coords.x, self.coords.y, self.coords.z + 1),
                maxDistance = self.distance,
            })
            if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
                exports.LGF_SpriteTextUI:removeTextUI(self.id)
                point:remove()
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for index, pumpEntity in ipairs(Pumps) do
            DeleteEntity(pumpEntity)
        end
    end
end)
