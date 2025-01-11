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
        }

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
            }
        })

        CreateThread(function()
            while self:hasActive() do
                Wait(0)
                for id in pairs(Hold.instances) do
                    self:check(id)
                end
            end
        end)
    end)

    return dui
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
    end
end

function Hold:check(id)
    local inst = self.instances[id]
    if not inst then return end


    if not self:isWithinDistance(id) then
        return
    end

    if IsControlPressed(0, inst.bindHold) then
        if not inst.holding then
            inst.holding = true
        end
    else
        if inst.holding then
            inst.holding = false
            if inst.isCompleted then
                inst.progress = 0
                inst.isCompleted = false
                inst.timeHeld = 0
            end
        end
    end

    self:update(id)
end

function Hold:remove(id)
    if self.instances[id] then
        local dui = self.instances[id].dui
        Hold:closeDui(id)

        SetTimeout(1000, function()
            dui:remove()
            self.instances[id] = nil
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
            Visible     = data.Visible,
            Message     = data.Message,
            Bind        = self.instances[id].bindKey or cfg.DefaultBind,
            UseOnlyBind = data.UseOnlyBind or false,
            CircleColor = data.CircleColor or cfg.DefaultColorCircle,
            Progress    = self.instances[id].progress,
        }
    })
end
