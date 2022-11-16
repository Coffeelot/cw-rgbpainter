# RGB Painter Script 🖌
A RGB vehicle paint script, standalone from any custom shops and scam price. The script comes with two usable items: A paint gun and a paint removal spray can. And also a paint canister that's needed to operate the paint gun.

Using the paint gun opens a menu where you can input RGB values (format example: "250 0 250") to paint Primary and Secondary. Pressing "Preview" opens the confirmation. You can back out from here and the script will reset your cars original color. If you have canister usage enabled you need to have 1-2 canisters on you to complete the painting. When you confirm the ped will do a lil animation and then you got a new color coat! It syncs to the database and creates a separate field to track coat (gloss, matte etc).

You can use the paint removal spray to remove RGB paints. This will reset the car to a base black color. 

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
**Support, updates and script previews**:

[![Join The discord!](https://cdn.discordapp.com/attachments/977876510620909579/1013102122985857064/discordJoin.png)](https://discord.gg/FJY4mtjaKr )

**All our scripts are and will remain free**. If you want to support what we do, you can buy us a coffee here:

[![Buy Us a Coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/cwscriptbois )

# Preview 📽
[![YOUTUBE VIDEO](http://img.youtube.com/vi/e2rvGW9WNLg/0.jpg)](https://youtu.be/e2rvGW9WNLg)

# Setup 👨‍💻
Find `QBCore.Functions.GetVehicleProperties` in `qb-core/client/functions.lua` and find the huge `return` object with all the fields. Add these fields somewhere in there (maybe after `color2 = colorSecondary,` i dont know im not your mom).
```
    color1Coat = GetVehicleModColor_1(vehicle),
    color2Coat = GetVehicleModColor_2(vehicle),
```
If you don't, opening the customs meny will remove the coats from this mod ‼

Open up `qb-garages/client/main.lua` and find the net event `'qb-garages:client:takeOutGarage'`. Put this somewhere in there (maybe after the `"vehiclekeys:client:SetOwner"` event call or something):
```
    TriggerEvent("cw-rgbpainter:client:handleTakeOutVehicle", veh, properties)
```

# Config 🔧
There are some settings you can modify in the config. Like being able to set if the script uses consumables, or if you need to be in paintbooths to use the items.

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua if you want to used the included item

```
["paint_gun"] =          {["name"] = "paint_gun",         ["label"] = "Spray Paint Gun",                  ["weight"] = 1, ["type"] = "item", ["image"] = "paint_gun.png", ["unique"] = false, ["useable"]= true, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Paint gun. Needs a canister to be used"},
["paint_canister"] =          {["name"] = "paint_canister",         ["label"] = "Paint Canister",                  ["weight"] = 1, ["type"] = "item", ["image"] = "paint_canister.png", ["unique"] =false, ["useable"] = true, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Paint canister for paint guns"},
["paint_removal_spray"] = {["name"] = "paint_removal_spray", ["label"] = "Paint Removal", ["weight"] = 1, ["type"] = "item", ["image"] = "paint_removal_spray.png", ["unique"] =false, ["useable"] = true, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Paint Removal for Vehicles"},
```
Also make sure the images are in qb-inventory>html>images

