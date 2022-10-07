local QBCore = exports['qb-core']:GetCoreObject()
local ogPrim = nil
local ogSec = nil
local ogPrimaryIsRGB, ogSecondaryIsRGB = false, false

RegisterNetEvent('cw-paintjobs:client:ChangeColor', function(r,g,b,type,coat, confirm)
    local ped = PlayerPedId()
	local vehicle = GetPlayersLastVehicle()
    print(vehicle)
    local plate = QBCore.Functions.GetPlate(vehicle)
    if type == '2' then
        if coat ~= nil then
            print('sec coat'.. coat)
            SetVehicleModColor_2(vehicle, tonumber(coat), 0, 0)
        end
        SetVehicleCustomSecondaryColour(vehicle,tonumber(r),tonumber(g),tonumber(b))
        if confirm then
            TriggerServerEvent('cw-paintjobs:server:ChangeColor',tonumber(r),tonumber(g),tonumber(b), 2, plate)
        end
    else
        if coat ~= nil then
            print('prim coat'.. coat)
            SetVehicleModColor_1(vehicle, tonumber(coat), 0, 0)
        end
        SetVehicleCustomPrimaryColour(vehicle,tonumber(r),tonumber(g),tonumber(b))
        if confirm then
            TriggerServerEvent('cw-paintjobs:server:ChangeColor',tonumber(r),tonumber(g),tonumber(b), 1, plate)
        end
    end
end)

local function splitColors(input)
    local result = {};
    for match in (input.." "):gmatch("(.-) ") do
        table.insert(result, match);
    end
    return result[1], result[2], result[3];
end 

function dump(o)
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

RegisterNetEvent("cw-paintjobs:client:openInteraction", function(canceled)
    if canceled == nil then
        TriggerEvent('animations:client:EmoteCommandStart', {"tablet2"})
    else
        TriggerEvent('cw-paintjobs:client:ChangeColor',ogPrim[1], ogPrim[2], ogPrim[3], "1")
        TriggerEvent('cw-paintjobs:client:ChangeColor', ogSec[1], ogSec[2], ogSec[3], "2")
    end

    if ogPrim == nil and ogSec == nil then
    	local vehicle = GetPlayersLastVehicle()
        ogPrim = {}
        ogSec = {}
        print(dump(QBCore.Functions.GetVehicleProperties(vehicle)))
        ogPrim[1], ogPrim[2], ogPrim[3] = GetVehicleCustomPrimaryColour(vehicle)
        ogSec[1], ogSec[2], ogSec[3] = GetVehicleCustomSecondaryColour(vehicle)
        local paintType, color, pearl = GetVehicleModColor_1(vehicle)
        print('orginal Primary ', ogPrim[1], ogPrim[2], ogPrim[3])
        print('original Secondary', ogSec[1], ogSec[2], ogSec[3])
        print('mod color 1', paintType)
        print('mod color 2', GetVehicleModColor_2(vehicle))
    end

    local dialog = exports['qb-input']:ShowInput({
        header = Config.PaintMenu.header,
        submitText = Config.PaintMenu.submitText,
        inputs = {
            {
                text = Config.PaintMenu.primary, -- text you want to be displayed as a place holder
                name = "primary", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
            },
            {
                text = "Color Type", -- text you want to be displayed as a input header
                name = "primaryType", -- name of the input should be unique otherwise it might override
                type = "radio", -- type of the input - Radio is useful for "or" options e.g; billtype = Cash OR Bill OR bank
                options = { -- The options (in this case for a radio) you want displayed, more than 6 is not recommended
                    { value = 1, text = "Gloss" }, -- Options MUST include a value and a text option
                    { value = 3, text = "Matte" }, -- Options MUST include a value and a text option
                    { value = 4, text = "Metal" }, -- Options MUST include a value and a text option
                    { value = 5, text = "Chrome" }, -- Options MUST include a value and a text option
                },
                default = 1, -- Default radio option, must match a value from above, this is optional
            },
            {
                text = Config.PaintMenu.secondary, -- text you want to be displayed as a place holder
                name = "secondary", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
            },
            {
                text = "Color Type", -- text you want to be displayed as a input header
                name = "secondaryType", -- name of the input should be unique otherwise it might override
                type = "radio", -- type of the input - Radio is useful for "or" options e.g; billtype = Cash OR Bill OR bank
                options = { -- The options (in this case for a radio) you want displayed, more than 6 is not recommended
                    { value = 1, text = "Gloss" }, -- Options MUST include a value and a text option
                    { value = 3, text = "Matte" }, -- Options MUST include a value and a text option
                    { value = 4, text = "Metal" }, -- Options MUST include a value and a text option
                    { value = 5, text = "Chrome" }, -- Options MUST include a value and a text option
                },
                default = 1, -- Default radio option, must match a value from above, this is optional
            },
        },
    })
    
    if dialog ~= nil then
        local data = { dialog["primary"], dialog["primaryType"], dialog["secondary"], dialog["secondaryType"] }
        if data[1] == '' and data[3] == '' then
            QBCore.Functions.Notify("You need to input at least one color", "error")
        end
        if data[1] ~= '' then
            local r, g, b = splitColors(data[1])
            print('primary: ', r..'/'..g..'/'..b.. " as "..data[2])
            TriggerEvent('cw-paintjobs:client:ChangeColor', r, g, b, "1", data[2])
        end
        if data[3] ~= '' then
            local r, g, b = splitColors(data[3])
            print('secondary: ', r..'/'..g..'/'..b.." as "..data[4])
            TriggerEvent('cw-paintjobs:client:ChangeColor', r, g, b, "2", data[4])
        end
        if data[1] ~= nil and data[3] ~= nil then
            TriggerEvent("cw-paintjobs:client:openConfirmInteraction", data[1], data[2],data[3],data[4])
        end
    else
        QBCore.Functions.Notify("Canceled Paintjob", "error")
        ogPrim = nil
        ogSec = nil
    end
end)

RegisterNetEvent("cw-paintjobs:client:openConfirmInteraction", function(primary, coatPrimary, secondary, coatSecondary)
    local dialog = exports['qb-input']:ShowInput({
        header = Config.ConfirmMenu.header,
        submitText = Config.ConfirmMenu.submitText,
        inputs = {},
    })
    
    if dialog ~= nil then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if QBCore.Functions.HasItem(Config.Items.canister) then
            print('HEYO HE HAS THE CANISTER!')
            if primary ~= '' then
                local r, g, b = splitColors(primary)
                TriggerEvent('cw-paintjobs:client:ChangeColor', r, g, b, "1", coatPrimary, true)
            end
            if secondary ~= '' then
                local r, g, b = splitColors(secondary)
                TriggerEvent('cw-paintjobs:client:ChangeColor', r, g, b, "2", coatSecondary, true)
                ogPrim = nil
                ogSec = nil
            end
        else
            QBCore.Functions.Notify("You got no paint on you", "error")
            TriggerEvent("cw-paintjobs:client:openInteraction", true)
        end
    else
        TriggerEvent("cw-paintjobs:client:openInteraction", true) 
        QBCore.Functions.Notify("Canceling confirmation", "error")
    end
end)

RegisterCommand('setcolor', function(source, args)
    TriggerEvent('cw-paintjobs:client:ChangeColor', args[1], args[2], args[3], args[4])    
end)

RegisterCommand('colormenu', function(source, args)
    TriggerEvent("cw-paintjobs:client:openInteraction")    
end)
