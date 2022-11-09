Config = {}

Config.Debug = false

Config.Items = {
    paintGun = 'paint_gun',
    canister = 'paint_canister',
    paintRemoval = 'paint_removal_spray'
}

Config.Props = {
    sprayCan = 'prop_cs_spray_can'
}

Config.Locations = {
    vector3(-326.1, -144.83, 39.06), -- BURTON LSC
    vector3(735.53, -1072.22, 22.23), --LA MESA LSC
    vector3(-1166.41, -2012.67, 13.23), --AIRPORT LSC
    vector3(1182.58, 2637.82, 37.8), -- HARMONY
    vector3(103.97, 6622.73, 31.83) -- PALETO
}

Config.Settings = {
    RemoveTime = 4000, -- Time it takes to use paint remover (in ms)
    PaintTime = 4000, -- Time it takes to paint a car (in ms)
    MaximumDistance = 5.0, -- Maximum distance away from vehicle you can be for removal or painter to work
    RemovalSprayCansAreUsedUp = true, -- Toggle if you want Paint Removal Cans to be used up as a consumable on usage
    CanistersAreUsedUp = true, -- Toggle if you want Paint canister to be used up as a consumeable on useage
    UseLocations = false, -- Toggle if you need to be in a paint booth or not. You can add more paint booths in Config.Locations. 
    MaximumLocationDistance = 20 , -- Maximum distance you can be from a paint booth in order to work on vehicles (can be toggled off with UseLocations above ^)
}