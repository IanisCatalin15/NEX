-- NEX.lua (Complete framework core)
NEX = {
    Services = {},
    Sessions = {},
    Metrics = { queries = 0, rpc_calls = 0 }
}

NEXFramework = {}
NEXFramework.__index = NEXFramework

function NEXFramework.New()
    local self = setmetatable({}, NEXFramework)
    self:Initialize()
    return self
end

function NEXFramework:Initialize()
    self:RegisterServices()
    self:SetupEventHandlers()
    NEXShared.Utils.Log('INFO', 'NEX Framework initialized')
end

function NEXFramework:RegisterServices()
    NEX.Services.User = UserService.New()
    NEX.Services.Database = Database.New()
end

function NEXFramework:SetupEventHandlers()
    AddEventHandler('playerDropped', function()
        local src = source
        NEX.Sessions[src] = nil
        NEXShared.Utils.Log('INFO', ('Player %s disconnected'):format(src))
    end)
end

function NEXFramework:Call(eventName, callback, timeout)
    local callId = NEXShared.Utils.GenerateUUID()
    local timedOut = false

    Citizen.CreateThread(function()
        Citizen.Wait(timeout or NEXShared.Constants.TIMEOUT_DEFAULT)
        if not timedOut then
            timedOut = true
            callback(nil, 'Request timed out')
        end
    end)

    RegisterNetEvent(NEXShared.Constants.EVENT_PREFIX .. eventName .. ':' .. callId)
    AddEventHandler(NEXShared.Constants.EVENT_PREFIX .. eventName .. ':' .. callId, function(data, err)
        if not timedOut then
            timedOut = true
            callback(data, err)
        end
    end)

    NEX.Metrics.rpc_calls = NEX.Metrics.rpc_calls + 1
    TriggerClientEvent(NEXShared.Constants.EVENT_PREFIX .. eventName, -1, callId)
end