local QBX = exports['qbx_core']

RegisterNetEvent('qb-rentals:server:rent', function(price, vehicle, time)
    local src = source
    local Player = QBX.PlayerData(src)
    local bank = Player.PlayerData.money['bank']
    local cash = Player.PlayerData.money['cash']
    local fullprice = price * time
    if cash >= tonumber(fullprice) then
        TriggerClientEvent('qb-rentals:client:rentvehiclespawn', src, vehicle, time)
        Player.Functions.RemoveMoney('cash', fullprice, 'rent_vehicle')
    elseif bank >= tonumber(fullprice) then
        TriggerClientEvent('qb-rentals:client:rentvehiclespawn', src, vehicle, time)
        Player.Functions.RemoveMoney('bank', fullprice, 'rent_vehicle')
    else
        QBX.Notify(src, Config.Notify.nomoney)
    end
end)
