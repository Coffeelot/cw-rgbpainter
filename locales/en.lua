local Translations = {
    paintMenu = {
        ["header"]                      = "RGB Color Painter 2002 (CRACKED by Xx_TEAM_CW_xX)",
        ["preview"]                     = "Preview",
        ["primaryDefault"]              = "Primary, (250 250 250)",
        ["secondaryDefault"]            = "Secondary, (250 250 250)",
        ["confirm"]                     = "Paint",
        ["confirmHeader"]               = "Confirm Paintjob? (press esc to go back)",
        ["colorType"]                   = "Color Type",
    },
    coatTypes = {
        ["gloss"]                      = "Gloss",
        ["matte"]                      = "Matte",
        ["metal"]                      = "Metal",
        ["chrome"]                      = "Chrome",

    },
    clearMenu = {
        ["header"]                      = "What paint do you want to remove?",
        ["primary"]                     = "Primary Coat",
        ["secondary"]                   = "Secondary Coat",
        ["both"]                        = "Both",
    },
    error = {
        ["distanceBooth"]                      = "You need to be in a paint booth",
        ["distanceVehicle"]                      = "You are to far away from the vehicle",
        ["primary"]                     = "Primary Coat",
        ["secondary"]                   = "Secondary Coat",
        ["both"]                        = "Both",
        ["canceled"]                        = "Canceled",
        ["primaryInput"]                        = "Your Primary input wasn't correct",
        ["secondaryInput"]                        = "You Secondary input wasn't correct",
        ["amountCanisters"]                        = "You do not have enough paint canisters on you",
        ["amountRemoval"]                        = "You dont have enought paint removal canisters on you",
        ["inputAmount"]                        = "You need to input at least one color",
        ["notAuthorized"]                        = "You lack the required job and/or rank to use this",
        
    },
    success = {
        ["paintRemoved"]                = "Custom paint removed. Make sure to park it in a garage before you modify it further"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
