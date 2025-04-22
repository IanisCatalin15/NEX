-- Cache for permissions
local PermissionCache = {}

-- Secure permission check with caching
function HasPermission(playerId, permission)
    local cacheKey = ('%s:%s'):format(playerId, permission)
    if PermissionCache[cacheKey] ~= nil then
        return PermissionCache[cacheKey]
    end

    local user = NEX:GetUser(playerId)
    if not user then
        PermissionCache[cacheKey] = false
        return false
    end

    for _, group in ipairs(user.groups) do
        for _, perm in ipairs(Groups[group].permissions or {}) do
            if perm == permission then
                PermissionCache[cacheKey] = true
                return true
            end
        end
    end

    PermissionCache[cacheKey] = false
    return false
end

-- Clear cache on user update
AddEventHandler('nex:user:updated', function(playerId)
    for key in pairs(PermissionCache) do
        if key:find(playerId) then
            PermissionCache[key] = nil
        end
    end
end)