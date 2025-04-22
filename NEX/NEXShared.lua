-- NEXShared.lua
NEXShared = {
    Config = {},
    Modules = {},
    Constants = {
        EVENT_PREFIX = 'nex:',
        TIMEOUT_DEFAULT = 5000, -- ms
        LOG_LEVELS = { ERROR = 1, WARN = 2, INFO = 3, DEBUG = 4 }
    },
    Utils = {}
}

-- Utility functions
NEXShared.Utils.ValidateType = function(value, expectedType)
    return type(value) == expectedType
end

NEXShared.Utils.SanitizeString = function(str)
    if not str or type(str) ~= 'string' then return '' end
    return str:gsub('[\\;]', '')
end

NEXShared.Utils.GenerateUUID = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 15) or math.random(8, 11)
        return string.format('%x', v)
    end)
end

NEXShared.Utils.Log = function(level, message)
    if level <= (NEXShared.Config.log_level or 0) then
        print(('[NEX][%s] %s'):format(level, message))
    end
end

-- Load configs
NEXShared.Config = {
    base = loadfile('cfg/base.lua')(),
    player_state = loadfile('cfg/player_state.lua')(),
    groups = loadfile('cfg/groups.lua')()
}