-- User.lua (Server-side user service)
UserService = {}
UserService.__index = UserService

function UserService.New()
    local self = setmetatable({}, UserService)
    self:Initialize()
    return self
end

function UserService:Initialize()
    -- Register commands
    RegisterCommand('getUserData', function(src, args)
        self:GetUserData(src, args[1], function(data, err)
            if err then
                TriggerClientEvent('chat:addMessage', src, { args = { '^1Error', err } })
            else
                TriggerClientEvent('chat:addMessage', src, { args = { '^2User Data', json.encode(data) } })
            end
        end)
    end, false)

    -- Register session initialization
    AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
        deferrals.defer()
        local src = source
        Citizen.Wait(100) -- Simulate async auth
        NEX.Sessions[src] = { group = 'user', id = NEXShared.Utils.GenerateUUID() }
        deferrals.done()
    end)
end

function UserService:GetUserData(playerId, userId, callback)
    if not NEXShared.Utils.ValidateType(userId, 'string') then
        callback(nil, 'Invalid user ID')
        return
    end

    local session = NEX.Sessions[playerId]
    if not session or not self:HasPermission(session, 'nex.user.getData') then
        callback(nil, 'Permission denied')
        return
    end

    NEX.Services.Database:ExecuteQuery(playerId, 'get_user', { user_id = userId }, function(result, err)
        callback(result, err)
    end)
end

function UserService:HasPermission(session, permission)
    local group = NEXShared.Config.groups[session.group]
    return group and table.contains(group.permissions, permission)
end