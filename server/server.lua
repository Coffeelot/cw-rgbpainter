local QBCore = exports['qb-core']:GetCoreObject()

local function mapCoat(coat)
    if coat == 1 then
        return 0
    else if coat == 3 then
        return 12
    else if coat == 4 then
        return 158
    else if coat == 5 then
        return 120
    else 
        return 1
    end
end

RegisterNetEvent('cw-paintjobs:server:ChangeColor', function(r,g,b, type, plate, coat)
    local src = source
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] then
        local mods = json.decode(result[1].mods)
        if type == 1 then
            mods.color1 = {r,g,b}
        else
            mods.color2 = {r,g,b}
        end
        MySQL.query('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(mods), plate})
    else
        print('problem')
    end

end)


QBCore.Functions.CreateUseableItem(Config.Items.paintGun, function(source, Item)
    TriggerClientEvent("cw-paintjobs:client:openInteraction", source)
end)
