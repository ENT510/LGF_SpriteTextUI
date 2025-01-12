if not lib then return end

TextUi = {}
TextUi.duiInstances = {}
local Config = require "Modules.Client.cl-config"
local screenWidth, screenHeight = GetActiveScreenResolution()
LocalPlayer.state.TextUiBusy = false


function TextUi:initializeDui(id, data)
    if not id then return end
    if not self.duiInstances[id] then
        --Peppe dont want premature loading
        while not self.duiInstances[id] do
            self.duiInstances[id] = {
                duiHandler = lib.dui:new({
                    url    = ('nui://%s/web/build/index.html'):format(cache.resource),
                    width  = screenWidth,
                    height = screenHeight,
                    debug  = Config.EnableDebug or false
                }),
            }
            Wait(500)
        end
    end

    local duiHandler = self.duiInstances[id].duiHandler
    LocalPlayer.state.TextUiBusy = data.Visible

    lib.waitFor(function()
        return duiHandler and IsDuiAvailable(duiHandler.duiObject)
    end, "WTF is Wrong?", 5000)

    self.duiInstances[id].duiData = data

    duiHandler:sendMessage({
        action = 'manageTextUI',
        data = {
            Visible     = data.Visible,
            Message     = data.Message,
            Bind        = data.Bind or Config.DefaultBind,
            UseOnlyBind = data.UseOnlyBind or false,
            CircleColor = data.CircleColor or Config.DefaultColorCircle,
            progress    = 100,
            BgColor     = data.BgColor or Config.DefaultBgColor
        }
    })

    if Config.EnableDebug then
        lib.print.info(("Processed Dui Handle with id %s"):format(id))
    end

    return duiHandler
end

function TextUi:render3DSprite(duiHandler, coords, maxDistance)
    local distance = #(GetEntityCoords(cache.ped) - coords)
    if distance > maxDistance then return end
    local scale = math.max(0.1, 1.5 / distance)
    scale = math.min(scale, 1.0)
    SetDrawOrigin(coords.x, coords.y, coords.z, false)
    DrawInteractiveSprite(duiHandler.dictName, duiHandler.txtName, 0, 0, scale, scale, 0.0, 255, 255, 255, 255)
    ClearDrawOrigin()
end

function TextUi:clearAllDuis()
    for id, duiInstance in pairs(self.duiInstances) do
        if duiInstance.duiHandler and duiInstance.duiHandler.remove then
            duiInstance.duiHandler:remove()
            if Config.EnableDebug then
                lib.print.info(("Removed Duis Handle with id %s"):format(id))
            end
        end
    end
    self.duiInstances = {}
end

function TextUi:close(id)
    local duiData = self.duiInstances[id]?.duiData
    local duiHandler = self.duiInstances[id]?.duiHandler


    if not duiHandler then return end

    duiHandler:sendMessage({
        action = 'manageTextUI',
        data = {
            Visible     = false,
            Message     = duiData.Message,
            Bind        = duiData.Bind,
            UseOnlyBind = duiData.UseOnlyBind,
            CircleColor = duiData.CircleColor,
            progress    = 100,
            BgColor     = duiData.BgColor or Config.DefaultBgColor
        }
    })
end

function TextUi:removeDui(id)
    if self.duiInstances[id] and self.duiInstances[id]?.duiHandler then
        local duiHandler = self.duiInstances[id]?.duiHandler
        TextUi:close(id)
        SetTimeout(1000, function()
            duiHandler:remove()
            self.duiInstances[id] = nil

            if Config.EnableDebug then
                lib.print.info(("Removed Dui Handle with id %s"):format(id))
            end
        end)
    else
        print(("Dui with ID '%s' not found."):format(id))
    end
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TextUi:clearAllDuis()
        if Config.EnableDebug then
            for index, pumpEntity in ipairs(Pumps) do
                DeleteEntity(pumpEntity)
            end
        end
    end
end)
