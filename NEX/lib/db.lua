-- lib/Database.lua
Database = {}
Database.__index = Database

function Database.New()
    local self = setmetatable({}, Database)
    self.queries = {} -- Cache for prepared queries
    self.metrics = { totalQueries = 0, totalTime = 0, failedQueries = 0 }
    self.rateLimits = {} -- Per-player rate limiting
    self:Initialize()
    return self
end

function Database:Initialize()
    -- Validate oxmysql dependency
    if not exports.oxmysql then
        NEXShared.Utils.Log('ERROR', 'oxmysql resource not found')
        return
    end

    self.API = exports.oxmysql
    self.connection = nil

    -- Wait for oxmysql to be ready
    MySQL.ready(function()
        self.connection = true
        NEXShared.Utils.Log('INFO', 'Database connected via oxmysql')
        self:LoadQueries()
    end)

    -- Register query execution event
    RegisterNetEvent(NEXShared.Constants.EVENT_PREFIX .. 'database:execute')
    AddEventHandler(NEXShared.Constants.EVENT_PREFIX .. 'database:execute', function(queryName, params, callId)
        local src = source
        self:ExecuteQuery(src, queryName, params, function(result, err)
            TriggerClientEvent(NEXShared.Constants.EVENT_PREFIX .. 'database:execute:' .. callId, src, result, err)
        end)
    end)
end

function Database:LoadQueries()
    -- Load all .sql files from sql/ folder
    local files = GetResourceFiles('sql', '%.sql$')
    for _, file in ipairs(files) do
        local queryName = file:match('^(.+)%.sql$')
        local query = loadfile('sql/' .. file)()
        if query then
            self.queries[queryName] = query
            NEXShared.Utils.Log('INFO', ('Loaded query: %s'):format(queryName))
        else
            NEXShared.Utils.Log('ERROR', ('Failed to load query: %s'):format(file))
        end
    end
end

function Database:ExecuteQuery(playerId, queryName, params, callback, mode)
    -- Validate inputs
    if not self.connection then
        callback(nil, 'Database not connected')
        return
    end

    if not self.queries[queryName] then
        callback(nil, ('Query %s not found'):format(queryName))
        return
    end

    -- Check permissions
    local session = NEX.Sessions[playerId]
    if not session or not self:HasPermission(session, 'nex.database.' .. queryName) then
        callback(nil, 'Permission denied')
        return
    end

    -- Rate limiting
    if not self:CheckRateLimit(playerId, queryName) then
        callback(nil, 'Rate limit exceeded')
        return
    end

    -- Sanitize params
    params = params or {}
    for k, v in pairs(params) do
        if type(v) == 'string' then
            params[k] = NEXShared.Utils.SanitizeString(v)
        end
    end

    -- Execute query
    local startTime = GetGameTimer()
    mode = mode or 'query'

    local success, result, err = pcall(function()
        if mode == 'execute' then
            return self.API:update(self.queries[queryName], params, function(affectedRows)
                self:LogQueryMetrics(queryName, startTime)
                callback(affectedRows or 0, nil)
            end)
        elseif mode == 'scalar' then
            return self.API:scalar(self.queries[queryName], params, function(result)
                self:LogQueryMetrics(queryName, startTime)
                callback(result, nil)
            end)
        else
            return self.API:query(self.queries[queryName], params, function(result, affected)
                self:LogQueryMetrics(queryName, startTime)
                callback(result, nil, affected)
            end)
        end
    end)

    if not success then
        self.metrics.failedQueries = self.metrics.failedQueries + 1
        NEXShared.Utils.Log('ERROR', ('Query %s failed: %s'):format(queryName, tostring(result)))
        callback(nil, tostring(result))
    end
end

function Database:CheckRateLimit(playerId, queryName)
    local now = GetGameTimer()
    self.rateLimits[playerId] = self.rateLimits[playerId] or {}
    local limit = self.rateLimits[playerId][queryName] or { count = 0, lastReset = now }

    -- Reset count every 60 seconds
    if now - limit.lastReset > 60000 then
        limit.count = 0
        limit.lastReset = now
    end

    -- Allow 10 queries per minute per player
    if limit.count >= 10 then
        return false
    end

    limit.count = limit.count + 1
    self.rateLimits[playerId][queryName] = limit
    return true
end

function Database:HasPermission(session, permission)
    local group = NEXShared.Config.groups[session.group]
    return group and table.contains(group.permissions, permission)
end

function Database:LogQueryMetrics(queryName, startTime)
    local duration = GetGameTimer() - startTime
    self.metrics.totalQueries = self.metrics.totalQueries + 1
    self.metrics.totalTime = self.metrics.totalTime + duration
    NEXShared.Utils.Log('DEBUG', ('Query %s took %d ms'):format(queryName, duration))
end

function Database:ExecuteBatch(queries, callback)
    local results = {}
    local errors = {}
    local completed = 0
    local total = #queries

    for _, q in ipairs(queries) do
        self:ExecuteQuery(0, q.name, q.params, function(result, err)
            completed = completed + 1
            results[q.name] = result
            errors[q.name] = err

            if completed == total then
                callback(results, errors)
            end
        end, q.mode)
    end
end

-- Helper function to get resource files (simplified)
function GetResourceFiles(path, pattern)
    local files = {}
    -- Placeholder: Implement file listing logic using FiveM's file API or Lua's io
    return files
end
