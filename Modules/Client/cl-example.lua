local Config = require "Modules.Client.cl-config"
if not Config.EnableDebug then return end
Pumps = {}



local pumpModels = {
    { model = "prop_gas_pump_1a", coords = vector3(-66.9443, 6544.8960, 30.4908), holdColor = "orange", bind = "E", bindToHold = 38 },
    { model = "prop_gas_pump_1a", coords = vector3(-60.2241, 6539.8809, 30.4908), holdColor = "teal",   bind = "F", bindToHold = 49 },
    { model = "prop_gas_pump_1a", coords = vector3(-52.0387, 6542.6284, 30.4909), holdColor = "violet", bind = "G", bindToHold = 47 },
}

-- CreateThread(function()
--     Wait(2000)
--     local duiHandlers = {}

--     for I = 1, #pumpModels do
--         local model = lib.requestModel(pumpModels[I].model)
--         if not model then return end
--         local pumpEntity = CreateObject(model, pumpModels[I].coords.x, pumpModels[I].coords.y, pumpModels[I].coords.z,
--             true, true, true)
--         Pumps[#Pumps + 1] = pumpEntity

--         local point = lib.points.new({
--             coords = pumpModels[I].coords,
--             distance = 4,
--         })

--         function point:onEnter()
--             duiHandlers[self.id] = exports.LGF_SpriteTextUI:HandleTextUI(self.id, {
--                 Visible = true,
--                 Message = ('Interact With Pump %s'):format(self.id),
--                 Bind = 'E',
--                 UseOnlyBind = false,
--                 CircleColor = "teal",

--             })
--             self.duiHandler = duiHandlers[self.id]
--         end

--         function point:onExit()
--             exports.LGF_SpriteTextUI:CloseTextUI(self.id)
--             duiHandlers[self.id] = nil
--         end

--         function point:nearby()
--             exports.LGF_SpriteTextUI:Draw3DSprite({
--                 duiHandler = self.duiHandler,
--                 coords = vec3(self.coords.x, self.coords.y, self.coords.z + 1),
--                 maxDistance = self.distance,
--             })
--             if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
--                 exports.LGF_SpriteTextUI:RemoveTextUI(self.id)
--                 point:remove()
--             end
--         end
--     end
-- end)

-- Example with Holder

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
            distance = 4,
        })


        function point:onEnter()
            duiHandlers[self.id] = exports.LGF_SpriteTextUI:HandleHoldTextUI(self.id, {
                Visible = true,
                Message = 'Hold to interact',
                Bind = pumpModels[I].bind,
                CircleColor = pumpModels[I].holdColor,
                UseOnlyBind = false,
                BindToHold = pumpModels[I].bindToHold,
                TimeToHold = 5,
                DistanceHold = 2,
                Coords = self.coords,
                canInteract = function(id, distance)
                    return true
                end,
                onCallback = function(id)
                    exports.LGF_SpriteTextUI:RemoveHoldTextUI(id)
                    point:remove()
                end
            })

            self.duiHandler = duiHandlers[self.id]
        end

        function point:onExit()
            exports.LGF_SpriteTextUI:CloseHoldTextUI(self.id)
            self.duiHandler = nil
        end

        function point:nearby()
            exports.LGF_SpriteTextUI:Draw3DSprite({
                duiHandler = self.duiHandler,
                coords = vec3(self.coords.x, self.coords.y, self.coords.z + 1),
                maxDistance = self.distance,
            })
        end
    end
end)
