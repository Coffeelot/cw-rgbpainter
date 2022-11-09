local QBCore = exports['qb-core']:GetCoreObject()

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

local function ClearColors(type, plate)
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if Config.Debug then
       print('removing colors in db for',  type, plate)
    end
    if result[1] then
        local mods = json.decode(result[1].mods)
        if type == '1' or type == nil then
            mods.color1Coat = nil
            mods.color1 = 1
        end
        if type == '2' or type == nil then
            mods.color2Coat = nil
            mods.color2 = 1
        end
        MySQL.query('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(mods), plate})
    else
        if Config.Debug then
            print('Could not find mods for this vehicle in database')
        end
    end
end

local function splitColors(input)
    local result = {};
    for match in (input.." "):gmatch("(.-) ") do
        table.insert(result, match);
    end
    return result[1], result[2], result[3];
end 

RegisterNetEvent('cw-rgbpainter:server:ChangeColor', function(Primary, Secondary, plate, Pcoat, Scoat)
    local src = source
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    local Pr, Pg, Pb = splitColors(Primary)
    local Sr, Sg, Sb = splitColors(Secondary)
    if Config.Debug then
       print('Primary color', Pr, Pg, Pb, Pcoat)
       print('Secondary color', Sr, Sg, Sb, Scoat)
    end
    if result[1] then
        local mods = json.decode(result[1].mods)
        if Pg then
            if Config.Debug then
               print('Painting primary')
            end
            mods.color1Coat = Pcoat
            mods.color1 = {Pr,Pg,Pb}
        end
        if Sg then
            if Config.Debug then
               print('Painting Secondary')
            end
            mods.color2Coat = Scoat
            mods.color2 = {Sr,Sg,Sb}
        end
        MySQL.query('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(mods), plate})
    else
        print('Could not find mods for this vehicle in database')
    end
end)

RegisterNetEvent('cw-rgbpainter:server:TakeItems', function(item, amount)
    if Config.Debug then
       print('Removing', item, amount)
    end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end)

RegisterNetEvent('cw-rgbpainter:server:ClearCustomColor', function(type, plate)
    ClearColors(type, plate)
end)


QBCore.Functions.CreateUseableItem(Config.Items.paintGun, function(source, Item)
    TriggerClientEvent("cw-rgbpainter:client:openInteraction", source)
end)

QBCore.Functions.CreateUseableItem(Config.Items.paintRemoval, function(source, Item)
    TriggerClientEvent("cw-rgbpainter:client:openClearInteraction", source)
end)

QBCore.Commands.Add('setcolor', 'Change the color plate of a vehicle. (Admin Only)',{ 
    { name = 'r', help='Red' },
    { name = 'g', help= 'Green' },
    { name = 'b', help= 'Blue' },
    { name = 'type', help= 'Primary=1 or Secondary=2' },
    { name = 'coat', help= 'Standard = 1, Matte = 3, Metal = 4, Chrome = 5' }
 }, true, function(source, args)
    TriggerClientEvent('cw-rgbpainter:client:ChangeColor', source, args[1], args[2], args[3], args[4], args[5], 'hello')    
end, 'admin')

QBCore.Commands.Add('clearcustomcolor', 'Clear custom color on vehicle (Admin Only)',{ { name = 'type', help = 'Primary=1 or Secondary=2, leave out if both' } }, false, function(source, args)
    local type = nil
    if args[1] then
        type = tostring(args[1])
    end
    TriggerClientEvent('cw-rgbpainter:client:ClearCustomColor', source, type)  
end, 'admin')
