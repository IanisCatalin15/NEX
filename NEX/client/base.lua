-- client/base.lua
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(NEXShared.Config.player_state.update_interval * 1000)
        TriggerServerEvent(NEXShared.Constants.EVENT_PREFIX .. 'player:stateUpdate', GetEntityCoords(PlayerPedId()))
    end
end)