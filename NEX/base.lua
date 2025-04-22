-- Base.lua (Server-side bootstrap)
Citizen.CreateThread(function()
    -- Initialize framework
    NEXFramework.New()
    NEXShared.Utils.Log('INFO', 'NEX Framework bootstrapped')
end)