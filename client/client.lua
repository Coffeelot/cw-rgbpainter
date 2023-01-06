local QBCore = exports['qb-core']:GetCoreObject()
local ogPrim = nil
local ogSec = nil
local ogPrimCoat = nil
local ogSecCoat = nil
local ogPearl = nil
local ogRims = nil
local ogPrimaryIsRGB, ogSecondaryIsRGB = false, false
local vehicleWorkedOn = nil
local attachedProp = 0

local useDebug = Config.Debug

-- DEBUG
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

local function splitColors(input)
    local result = {};
    for _, val in pairs(input) do
        table.insert(result, val);
    end
    return result[1], result[2], result[3];
end 

local function showNonLoopParticle(dict, particleName, scale, r,g,b, objectToAttachTo, offset)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    if r == nil or g == nil or g == nil then
        r, g, b = 0.0, 0.0, 0.0
    end
    if useDebug then
       print('Particles R G B', r,g,b)
    end
    SetParticleFxNonLoopedColour(r,g,b)
    local particleHandle  StartNetworkedParticleFxNonLoopedOnEntity(particleName, objectToAttachTo, 0.0, offset, 0.0, 0.0, 0.0, 0.0,
        scale, false, false, false)
    return particleHandle
end

local function handleSpray(color)
    local r,g,b
    if useDebug then
       print('handlespray', dump(color))
    end
    if color then
        r,g,b = splitColors(color)
        r,g,b = r/250.0, g/250.0, b/250.0
    end

    local x, y, z ,h = 0, 0 ,0 ,0
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local coordinates = {x=x,y=y,z=z,h=h}

    local Size = 1.0
    if not vehicleWorkedOn then
        local vehicle = GetPlayersLastVehicle()
        vehicleWorkedOn = vehicle
    end
    local offset = math.random(-20,20)*0.1
    if useDebug then
       print('Spray offset', offset)
    end

    local particle = showNonLoopParticle('core', 'veh_respray_smoke', Size, r, g, b, vehicleWorkedOn, offset)
end

local function handleSprayCanSpray(color)
    local r,g,b
    if useDebug then
        print('can handlespray', dump(color))
     end
    if color then
        r,g,b = splitColors(color)
        r,g,b = r/250.0, g/250.0, b/250.0
    end

    local x, y, z ,h = 0, 0 ,0 ,0
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)

    local Size = 0.2
    local particle = showNonLoopParticle('core', 'veh_respray_smoke', Size, r, g, b, attachedProp,0.0)
end

local function changeColors(r, g, b, type, coat, pearl, rims)
    if type == '1' then
        if useDebug then
           print('updating primary', r, g, b)
        end
        if coat ~= nil then
            if not pearl then
                pearl = 0
            end
            if not rims then
                rims = 0
            end
            SetVehicleModColor_1(vehicleWorkedOn, tonumber(coat), 0, pearl)
            SetVehicleExtraColours(vehicleWorkedOn, pearl, rims)
            SetVehicleCustomPrimaryColour(vehicleWorkedOn, tonumber(r),tonumber(g),tonumber(b))
        end
    end
    if type == '2' then
        if useDebug then
           print('updating secondary', r, g, b)
        end
        if coat ~= nil then
            SetVehicleModColor_2(vehicleWorkedOn, tonumber(coat), 0)
            SetVehicleCustomSecondaryColour(vehicleWorkedOn, tonumber(r),tonumber(g),tonumber(b))
        end
    end
end

local function clearProp()
    if useDebug then
       print('REMOVING PROP', attachedProp)
    end
    if DoesEntityExist(attachedProp) then
        DeleteEntity(attachedProp)
        attachedProp = 0
    end
end

local function attachSprayCan()
    clearProp()
    local model = Config.Props.sprayCan
    local boneNumber = 57005
    SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    attachedProp = CreateObject(model, 1.0, 1.0, 1.0, 1, 1, 0)
    local x, y,z = 0.11,0.02, -0.02
    local xR, yR, zR = 20.0, 70.0, 70.0
    AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 0, true, false, true, 2, true)
end

RegisterNetEvent('cw-rgbpainter:client:ChangeColor', function(r,g,b,type,coat, command)
    if command then
        local vehicle = GetPlayersLastVehicle()
        vehicleWorkedOn = vehicle
    end
    local pearlescentColor, rimsColor = GetVehicleExtraColours(vehicleWorkedOn)
    changeColors(r,g,b,type,coat, pearlescentColor, rimsColor)
end)

local function clearCustomColor(type, onlyLocal)

    local vehicle = GetPlayersLastVehicle()
    vehicleWorkedOn = vehicle
    Wait(100)
    if type == '1' then
        if useDebug then
           print('clearing primary')
        end
        ClearVehicleCustomPrimaryColour(vehicleWorkedOn)
        if not onlyLocal then
            if not ogPearl then 
                ogPearl = 0
            end
            SetVehicleModColor_1(vehicleWorkedOn, 0, 0, ogPearl)
            SetVehicleExtraColours(vehicleWorkedOn, ogPearl, ogRims)
        end
    elseif type == '2' then
        if useDebug then
           print('clearing secondary')
        end
        ClearVehicleCustomSecondaryColour(vehicleWorkedOn)
        if not onlyLocal then
            SetVehicleModColor_2(vehicleWorkedOn, 0, 0)
        end
    end
    if type == nil then
        if useDebug then
           print('clearing both')
        end
        clearCustomColor('1')
        Wait(20)
        clearCustomColor('2')
    end
    if not onlyLocal then
        local plate = QBCore.Functions.GetPlate(vehicle)
        TriggerServerEvent('cw-rgbpainter:server:ClearCustomColor', type, plate)
        vehicleWorkedOn = nil
    end
end

local function isInAPaintBooth(playerCoords)
    if Config.Settings.UseLocations then
        for i, spot in pairs(Config.Locations) do
            local distance = GetDistanceBetweenCoords(playerCoords,spot,true)
            print(distance)
            if  distance < Config.Settings.MaximumLocationDistance then
                return true
            end
        end
        QBCore.Functions.Notify(Lang:t('error.distanceBooth'), "error")
        return false
    else
        return true
    end
end

local function hasAuth()
    if Config.Settings.UseJobRequirements then
        local Player = QBCore.Functions.GetPlayerData()
        local playerHasJob = Config.AllowedJobs[Player.job.name]
        local jobGradeReq = nil
        if useDebug then
           print('Player job: ', Player.job.name)
           print('Allowed jobs: ', dump(Config.AllowedJobs))
        end
        
        if playerHasJob then
            if useDebug then
               print('Player job level: ', Player.job.grade.level)
            end
            if Config.AllowedJobs[Player.job.name] ~= nil then
                jobGradeReq = Config.AllowedJobs[Player.job.name].minimumRank
                if useDebug then
                   print('Required job grade: ', jobGradeReq)
                end
            end      
            if jobGradeReq ~= nil then
                if Player.job.grade.level >= jobGradeReq then
                    return true
                end
            end
        end
        QBCore.Functions.Notify(Lang:t('error.notAuthorized'), "error")
        return false
    else
        return true
    end
end

local function isWithinReach(playerCoords, vehicleCoords)
    local distance = GetDistanceBetweenCoords(playerCoords,vehicleCoords,true)
    if useDebug then
       print('Distance to vehicle', distance)
    end
    if Config.Settings.MaximumDistance > distance then
        return true
    end

    QBCore.Functions.Notify(Lang:t('error.distanceVehicle'), "error")
    return false
end

RegisterNetEvent('cw-rgbpainter:client:ClearCustomColor', function(type)
    clearCustomColor(type)
end)

RegisterNetEvent('cw-rgbpainter:client:ClearCustomColorFromMenu', function(data)
    attachSprayCan()
    handleSprayCanSpray()
    local canisterAmount = 0
    if Config.Settings.RemovalSprayCansAreUsedUp then
        if useDebug then
           print('Removal sprays usage is enabled', data[1])
        end
        if data[1] == '1' or data[1] == '2' then
            canisterAmount = 1
        else
            canisterAmount = 2
        end
    end
    if QBCore.Functions.HasItem(Config.Items.paintRemoval, canisterAmount) then
        ogPearl, ogRims = GetVehicleExtraColours(GetPlayersLastVehicle())

        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
        if Config.Settings.RemovalSprayCansAreUsedUp then
            TriggerServerEvent('cw-rgbpainter:server:TakeItems', Config.Items.paintRemoval, canisterAmount)
        end
        QBCore.Functions.Progressbar("removing_paint", Lang:t('info.removing_paint'), Config.Settings.RemoveTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            handleSpray()
            clearCustomColor(data[1])
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            clearProp()
            QBCore.Functions.Notify(Lang:t('success.paintRemoved'), "success")
        end, function() -- Cancel
            clearProp()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify(Lang:t('error.canceled'), "error")
        end)
    else
        QBCore.Functions.Notify(Lang:t('error.amountRemoval'), "error")
    end
end)

local function openClearMenu()
    exports['qb-menu']:openMenu({{
        header = Lang:t('clearMenu.header'),
        isMenuHeader = true
    }, {
        header = Lang:t('clearMenu.primary'),
        params = {
            event = 'cw-rgbpainter:client:ClearCustomColorFromMenu',
            args = {'1'}
        }
    }, {
        header = Lang:t('clearMenu.secondary'),
        params = {
            event = 'cw-rgbpainter:client:ClearCustomColorFromMenu',
            args = {'2'}

        }
    }, {
        header = Lang:t('clearMenu.both'),
        params = {
            event = 'cw-rgbpainter:client:ClearCustomColorFromMenu',
            args = {nil}
        }
    }})
end

RegisterNetEvent("cw-rgbpainter:client:openClearInteraction", function()
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    local vehicle = GetPlayersLastVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    if isInAPaintBooth(playerCoords) and isWithinReach(playerCoords,vehicleCoords) and hasAuth() then
        openClearMenu()
    end
end)

local function validateColors(r,g,b)
    local result = 0
    if r then
        result = result + 1
    end
    if g then
        result = result + 1
    end
    if b then
        result = result + 1
    end        
    return result
end

RegisterNetEvent("cw-rgbpainter:client:handleTakeOutVehicle", function(veh, mods)
    local primary = mods.color1
    local secondary = mods.color2
    vehicleWorkedOn = veh
    Wait(100)
    if type(mods.color1) == 'table' then
        local Pr, Pg, Pb = mods.color1[1], mods.color1[2], mods.color1[3]
        if useDebug then
            print('Takeout: Primary', Pr, Pg, Pb)
            print('Takeout: Primary coat', mods.color1Coat)
            print('Takeout: Primary pearl', mods.pearlescentColor)
        end
        changeColors(Pr, Pg, Pb, '1', mods.color1Coat, mods.pearlescentColor, mods.wheelColor)
    end
    Wait(100)
    if type(mods.color2) == 'table' then
        local Sr, Sg, Sb = mods.color2[1], mods.color2[2], mods.color2[3]
        if useDebug then
            print('Takeout: Secondary', Sr, Sg, Sb)
            print('Takeout: Secondary coat', mods.color2Coat)
        end
        changeColors(Sr, Sg, Sb, '2', mods.color2Coat, mods.pearlescentColor)
    end
    vehicleWorkedOn = nil
end)

local function resetCarWorkedOn()
    ogPrim = nil
    ogSec = nil
    ogPrimCoat = nil
    ogSecCoat = nil
    ogPearl = nil
    ogRims = nil
    ogPrimaryIsRGB, ogSecondaryIsRGB = false, false
    vehicleWorkedOn = nil
end

local function resetColors()
    if useDebug then
       print('ogPrim', dump(ogPrim), 'ogPrim Coat', ogPrimCoat, 'og pearl', ogPearl, 'og rims', ogRims,'is RGB', ogPrimaryIsRGB)
       print('ogSec', dump(ogSec), 'ogPrim Coat', ogSecCoat, 'is RGB', ogSecondaryIsRGB)
       print('Vehicle worked on:', vehicleWorkedOn)
    end

    local tOgPrim, tOgSec = 0, 0
    if not ogPrimaryIsRGB then
        tOgPrim = ogPrim
    end
    if not ogSecondaryIsRGB then
        tOgSec = ogSec
    end
    SetVehicleColours(vehicleWorkedOn, tOgPrim  , tOgSec)

    if ogPrimaryIsRGB then
        changeColors(ogPrim[1],ogPrim[2],ogPrim[3],'1', ogPrimCoat, ogPearl, ogRims)
    else
        clearCustomColor('1', true)
        if ogPrimCoat == 7 then
            ogPrimCoat = 0
        end
        SetVehicleModColor_1(vehicleWorkedOn,ogPrimCoat, tonumber(ogPrim), ogPearl)
    end
    if ogSecondaryIsRGB then
        changeColors(ogSec[1],ogSec[2],ogSec[3],'2', ogSecCoat)
    else
        clearCustomColor('2', true)
        SetVehicleModColor_2(vehicleWorkedOn,ogSecCoat, ogSec)
    end
    SetVehicleExtraColours(vehicleWorkedOn, ogPearl, ogRims)
    resetCarWorkedOn()
    --TriggerEvent("cw-rgbpainter:client:openInteraction", true) 
    QBCore.Functions.Notify(Lang:t('error.canceled'), "error")
end

local function handleConfirm(primary, coatPrimary, secondary, coatSecondary)
    local ped = PlayerPedId()
	local vehicle = GetPlayersLastVehicle()
    local plate = QBCore.Functions.GetPlate(vehicle)
    local canisterAmount = 0
    if Config.Settings.CanistersAreUsedUp then
        if useDebug then
           print('Canister usage is enabled')
        end
        if #primary > 1 then
            canisterAmount = canisterAmount+1
        end
        if #secondary > 1 then
            canisterAmount = canisterAmount+1
        end
    end
    if useDebug then
       print('Canisters needed:', canisterAmount)
    end

    if QBCore.Functions.HasItem(Config.Items.canister, canisterAmount) then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if Config.Settings.CanistersAreUsedUp then
            TriggerServerEvent('cw-rgbpainter:server:TakeItems', Config.Items.canister, canisterAmount)
        end

        attachSprayCan()
        if useDebug then
            print('colors to spray', dump(primary), dump(secondary))
         end
        if #primary > 0 then
            handleSprayCanSpray(primary)
        end
        if #secondary > 0 then
            handleSprayCanSpray(secondary)
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
        QBCore.Functions.Progressbar("open_cw_laptop", Lang:t('info.applying_paint'), Config.Settings.PaintTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            if #primary > 0 then
                handleSpray(primary)
            end
            if #secondary > 0 then
                handleSpray(secondary)
            end
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            clearProp()
            TriggerServerEvent('cw-rgbpainter:server:ChangeColor', primary, secondary, plate, coatPrimary, coatSecondary)
            resetCarWorkedOn()
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            clearProp()
            QBCore.Functions.Notify(Lang:t('error.canceled'), "error")
            resetColors()
        end)
    else
        QBCore.Functions.Notify(Lang:t('error.amountCanisters'), "error")
        TriggerEvent("cw-rgbpainter:client:openInteraction", true)
        resetColors()
    end
end


local function setPaintingOpen(bool, i)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    local citizenId = QBCore.Functions.GetPlayerData().citizenid
    if useDebug then
        print('hhiehiehei', i)
    end
    if useDebug then
        print('Crafting was opened')
    end
    SetNuiFocus(bool, bool)
    if bool then
        local vehicle = GetPlayersLastVehicle()
        vehicleWorkedOn = vehicle
        if ogPrim == nil or ogSec == nil then
            local vehicleProps = QBCore.Functions.GetVehicleProperties(vehicle)
            ogPrim = vehicleProps.color1
            ogSec = vehicleProps.color2
            if type(ogPrim) == 'table' then
                ogPrimaryIsRGB = true
            else
                ogPrimaryIsRGB = false
            end
            if type(ogSec) == 'table' then
                ogSecondaryIsRGB = true
            else
                ogSecondaryIsRGB = false
            end
    
            ogPrimCoat = GetVehicleModColor_1(vehicle)
            ogPearl, ogRims = GetVehicleExtraColours(vehicle)
            ogSecCoat = GetVehicleModColor_2(vehicle)
    
            if useDebug then
               print('Original coats: ', ogPrimCoat,ogSecCoat, 'original pearl:', ogPearl)
            end
        end
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end
    SendNUIMessage({
        action = "cwRGB",
        toggle = bool
    })
end

RegisterNetEvent("cw-rgbpainter:client:openMenu", function()
    setPaintingOpen(true)
end)

RegisterNUICallback('handleColor', function(values, cb)
    local r = values.r
    local g = values.g
    local b = values.b
    local coat = values.coat
    local type = values.type
    if useDebug then
       print('painting in', r,g,b, coat, type)
    end
    TriggerEvent('cw-rgbpainter:client:ChangeColor', r, g, b, coat, type)
    cb(true)
end)


RegisterNUICallback('attemptPaint', function(values, cb)
    setPaintingOpen(false)
    local primary = { values.primary["rP"], values.primary["gP"], values.primary["bP"] }
    local secondary = { values.secondary["rS"], values.secondary["gS"], values.secondary["bS"] }
    local coatPrimary = values.coatPrimary
    local coatSecondary = values.coatSecondary
    if useDebug then
       print('confirm', dump(primary), dump(secondary))
    end
    handleConfirm(primary, coatPrimary, secondary, coatSecondary)
    cb(true)
end)

RegisterNUICallback('getOGcolors', function(_, cb)
    if not ogPrimaryIsRGB and not ogSecondaryIsRGB then
        if useDebug then
           print('original were not rgb')
        end
        cb(false)
    else
        cb({prim=ogPrim, sec=ogSec, primType = ogPrimCoat, secType = ogSecCoat})   
    end
end)


RegisterNUICallback('closePaint', function()
    setPaintingOpen(false)
    resetColors()
end)


RegisterCommand('openPaint', function(source)
    if useDebug then
        print('Open ppaint')
    end
    setPaintingOpen(true)
end)

-- RegisterNUICallback('getRecipes', function(data, cb)
--     if useDebug then
--        print('Fetching recipes')
--     end
--     getRecipes()
--     cb(Recipes)
-- end)

-- RegisterNUICallback('closeCrafting', function(_, cb)
--     if useDebug then
--         print('Closing crafting')
--     end
--     setCraftingOpen(false)
--     cb('ok')
-- end)

RegisterNUICallback('getInventory', function(_, cb)
    cb(Config.Inventory)
end)


RegisterCommand('removeCan', function ()
    clearProp()
end)

RegisterNetEvent('cw-rgbpainter:client:toggleDebug', function(debug)
   print('Setting debug to',debug)
   useDebug = debug
end)