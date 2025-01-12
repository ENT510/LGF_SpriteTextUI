if not lib then return end

Hold = {}
Hold.instances = {}

local cfg = require "Modules.Client.cl-config"
local screenW, screenH = GetActiveScreenResolution()

function Hold:isWithinDistance(id)
    local inst = self.instances[id]
    if not inst then return false end
    local playerCoords = GetEntityCoords(cache.ped)
    local interactionCoords = vector3(inst.coords.x, inst.coords.y, inst.coords.z)
    local distance = #(playerCoords - interactionCoords)
    return distance <= inst.distanceHold
end

function Hold:init(id, data)
    if not id then return end
    if not self.instances[id] then
        self.instances[id] = {
            dui          = lib.dui:new({
                url    = ('nui://%s/web/build/index.html'):format(cache.resource),
                width  = screenW,
                height = screenH,
                debug  = cfg.EnableDebugHolder or false
            }),
            progress     = 0,
            bindKey      = data.Bind or 'E',
            maxProgress  = 100,
            holding      = false,
            bindHold     = data.BindToHold or 38,
            timeToHold   = data.TimeToHold or 10,
            timeHeld     = 0,
            onCallback   = data.onCallback or nil,
            isCompleted  = false,
            coords       = data.Coords or { x = 0, y = 0, z = 0 },
            distanceHold = data.DistanceHold or 3,
            canInteract  = data.canInteract or true,
            id           = id
        }

        Hold:startThread(id)

        print("started")

        lib.waitFor(function()
            return self.instances[id].dui and IsDuiAvailable(self.instances[id].dui.duiObject)
        end, "ok", 5000)
    end

    LocalPlayer.state.TextUiBusy = data.Visible
    self.instances[id].intData = data

    local dui = self.instances[id].dui
    SetTimeout(600, function()
        dui:sendMessage({
            action = 'manageTextUI',
            data = {
                Visible     = data.Visible,
                Message     = data.Message,
                Bind        = self.instances[id].bindKey or cfg.DefaultBind,
                UseOnlyBind = data.UseOnlyBind or false,
                CircleColor = data.CircleColor or cfg.DefaultColorCircle,
                Progress    = self.instances[id].progress,
                BgColor     = data.BgColor or cfg.DefaultBgColor
            }
        })
    end)

    return dui
end

function Hold:startThread(id)
    self.instances[id].thread = CreateThread(function()
        while self:hasActive() do
            if not self.instances[id] then break end
            Wait(0)
            self:check(id)
        end
    end)
end

function Hold:update(id)
    local inst = self.instances[id]
    if not inst then return end

    if not self:isWithinDistance(id) then
        inst.progress = 0
        inst.timeHeld = 0
        inst.holding = false
        return
    end

    if inst.holding then
        inst.timeHeld = math.min(inst.timeHeld + GetFrameTime(), inst.timeToHold)
        inst.progress = math.min((inst.timeHeld / inst.timeToHold) * 100, inst.maxProgress)
    elseif inst.isCompleted then
        inst.progress = math.max(inst.progress - 1, 0)
    else
        inst.timeHeld = 0
        inst.progress = 0
    end

    inst.dui:sendMessage({
        action = 'updateProgress',
        data = { Progress = inst.progress }
    })

    if inst.progress == 100 and inst.onCallback and not inst.isCompleted then
        inst.onCallback(id)
        inst.isCompleted = true

        Hold:reset(id)
    end
end

function Hold:check(id)
    local inst = self.instances[id]
    if not inst then return end

    local interactionCoords = vector3(inst.coords.x, inst.coords.y, inst.coords.z)
    local distance = #(GetEntityCoords(cache.ped) - interactionCoords)

    if not self:isWithinDistance(id) then
        return
    end

    if not inst.canInteract(id, distance) then
        return
    end

    if cfg.EnableDebug then
        lib.print.info(msgpack.unpack(msgpack.pack(inst)))
    end

    if IsControlPressed(0, inst.bindHold) then
        if not inst.holding then
            inst.holding = true
        end
    else
        if inst.holding then
            inst.holding = false

            if inst.isCompleted then
                Hold:reset(id)
            end
        end
    end

    self:update(id)
end

function Hold:remove(id)
    local inst = self.instances[id]
    if inst then
        Hold:reset(id)
        Hold:closeDui(id)
        Hold:stopThread(id)

        self.instances[id] = nil

        SetTimeout(1000, function()
            if inst.dui then
                inst.dui:remove()
            end
        end)
    end
end

function Hold:hasActive()
    return LocalPlayer.state.TextUiBusy == true
end

function Hold:closeDui(id)
    local dui = self.instances[id].dui
    local data = self.instances[id].intData


    dui:sendMessage({
        action = 'manageTextUI',
        data = {
            Visible     = false,
            Message     = data.Message,
            Bind        = self.instances[id].bindKey or cfg.DefaultBind,
            UseOnlyBind = data.UseOnlyBind or false,
            CircleColor = data.CircleColor or cfg.DefaultColorCircle,
            Progress    = 0,
            BgColor     = data.BgColor or cfg.DefaultBgColor
        }
    })
end

function Hold:stopThread(id)
    if self.instances[id] and self.instances[id].thread then
        self.instances[id].thread = nil
    end
end

function Hold:reset(id)
    local inst = self.instances[id]
    if not inst then return end

    inst.progress = 0
    inst.timeHeld = 0
    inst.holding = false
    inst.isCompleted = false
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for id, _ in pairs(Hold.instances) do
            Hold:remove(id)
        end
        if cfg.EnableDebug then
            for index, pumpEntity in ipairs(Pumps) do
                DeleteEntity(pumpEntity)
            end
        end
    end
end)
