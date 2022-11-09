# cw-rgbpainter 🖨
A standalone RGB vehicle paint script. The script comes with two usable items: A paint gun and a paint removal spray can. And also a paint canister that's needed to operate the paint gun.

Using the paint gun opens a menu where you can input RGB values (format example: "250 0 250") to paint Primary and Secondary. Pressing "Preview" opens the confirmation. You can back out from here and the script will reset your cars original color. If you have canister usage enabled you need to have 1-2 canisters on you to complete the painting. When you confirm the ped will do a lil animation and then you got a new color coat! It syncs to the database and creates a separate field to track coat (gloss, matte etc).

You can use the paint removal spray to remove RGB paints. This will reset the car to a base black color. 

Coming super soon: Job requirements. 

# Preview 📽
COMING SOON 
# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
[Support, updates and script previews](https://discord.gg/FJY4mtjaKr) 👈
# Config 🔧
There are some settings you can modify in the config. Like being able to set if the script uses consumables, or if you need to be in paintbooths to use the items.

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua if you want to used the included item

```
["paint_gun"] =          {["name"] = "paint_gun",         ["label"] = "Spray Paint Gun",                  ["weight"] = 1, ["type"] = "item", ["image"] = "paint_gun.png", ["unique"] = false, ["useable"]= true, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Paint gun. Needs a canister to be used"},
["paint_canister"] =          {["name"] = "paint_canister",         ["label"] = "Paint Canister",                  ["weight"] = 1, ["type"] = "item", ["image"] = "paint_canister.png", ["unique"] =false, ["useable"] = true, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Paint canister for paint guns"},
```
Also make sure the images are in qb-inventory>html>images

