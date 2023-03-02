v2r = require("BoolyScript/pages/recovery-v2/include")

local c = scripts.globals.getCharId()

local tag = {nil, nil, nil, nil}

V2:add_click_option("Nightclub Scam", "BS_RecoveryV2_Nightclub_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. c .."_PROP_NIGHTCLUB_VALUE"), 2004500000)
    if tag[1] == nil then tag[1] = "[Done]" option:addTag({tag[1], math.random(255), math.random(255), math.random(255)}) end
    notify.important("Real Estate Scam", "Now purchase another Nightclub and replace it")
end):setTags({{"[Risky]", 252, 43, 85}}):setHint("Purchase a Nightclub -> Activate this option -> Purchase another Nightclub and replace it")

V2:add_click_option("Hangar Scam", "BS_RecoveryV2_Hangar_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. c .."_PROP_HANGAR_VALUE"), 2004500000)
    if tag[2] == nil then tag[2] = "[Done]" option:addTag({tag[2], math.random(255), math.random(255), math.random(255)}) end
    notify.important("Real Estate Scam", "Now purchase another Hangar and replace it")
end):setTags({{"[Risky]", 252, 43, 85}}):setHint("Purchase a Hangar -> Activate this option -> Purchase another Hangar and replace it")

V2:add_click_option("Clubhouse Scam", "BS_RecoveryV2_Clubhouse_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. c .."_PROP_CLUBHOUSE_VALUE"), 2004500000)
    if tag[3] == nil then tag[3] = "[Done]" option:addTag({tag[3], math.random(255), math.random(255), math.random(255)}) end
    notify.important("Real Estate Scam", "Now purchase another Clubhouse and replace it")
end):setTags({{"[Risky]", 252, 43, 85}}):setHint("Purchase a Clubhouse -> Activate this option -> Purchase another Clubhouse and replace it")

V2:add_click_option("Auto Shop Scam", "BS_RecoveryV2_AS_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. c .."_PROP_AUTO_SHOP_VALUE"), 2004500000)
    if tag[4] == nil then tag[4] = "[Done]" option:addTag({tag[4], math.random(255), math.random(255), math.random(255)}) end
    notify.important("Real Estate Scam", "Now purchase another Auto Shop and replace it")
end):setTags({{"[Risky]", 252, 43, 85}}):setHint("Purchase an Auto Shop -> Activate this option -> Purchase another Auto Shop and replace it")

V2:add_separator("Unlocks", "BS_RecoveryV2_Unl")

V2:add_click_option("Everything", "BS_RecoveryV2_Everything", function(option)
    v2r.unlockClothes(c)
    v2r.unlockAdminStuff(c)
    v2r.unlockTattoos(c)
    v2r.unlockWeapons(c)
    v2r.unlockExclusiveContent()
    v2r.unlockChallenges()
    v2r.unlockFastRunPlusReload(c)
    v2r.unlockVehicleMods(c)
    v2r.unlockXmas(c)
    v2r.unlockValentines(c)
    v2r.unlockMovieProps(c)
    v2r.unlockPilotSchool(c)
    v2r.unlockPropertyAccess(c)
    v2r.unlockObjectives(c)
    v2r.unlockShotaro(c)
    v2r.unlockArmoredParagon(c)
    v2r.awards(c)
    v2r.health(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Everything", "Success")
end):setHint("Unlocks everything below except Extra, Musket, Firework Launcher")

V2:add_click_option("Extra", "BS_RecoveryV2_Extra", function(option)
    v2r.unlockExtra(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Extra", "Success")
end)

V2:add_click_option("Clothes", "BS_RecoveryV2_CL", function(option)
    v2r.unlockClothes(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Clothes", "Success")
end)

V2:add_click_option("Rockstar Clothes", "BS_RecoveryV2_RCL", function(option)
    v2r.unlockAdminStuff(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Rockstar Stuff", "Success")
end)

V2:add_click_option("Tattoos", "BS_RecoveryV2_TT", function(option)
    v2r.unlockTattoos(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Tattoos", "Success")
end)

V2:add_click_option("Weapons", "BS_RecoveryV2_WP", function(option)
    v2r.unlockWeapons(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Weapons", "Success")
end)

V2:add_click_option("Exclusive Content", "BS_RecoveryV2_EC", function(option)
    v2r.unlockExclusiveContent()
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Exclusive Content", "Success")
end)

V2:add_click_option("Challenges", "BS_RecoveryV2_CLL", function(option)
    v2r.unlockChallenges()
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Challenges", "Success")
end)

V2:add_click_option("Fast Run + Reload", "BS_RecoveryV2_FRR", function(option)
    v2r.unlockFastRunPlusReload(c)
    option:setTags({{"[Applied]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Apply Fast Run + Reload", "Switch session to apply")
end)

V2:add_click_option("Vehicle Mods", "BS_RecoveryV2_VM", function(option)
    v2r.unlockVehicleMods(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Vehicle Mods", "Success")
end)

V2:add_click_option("Xmas Stuff", "BS_RecoveryV2_XMAS", function(option)
    v2r.unlockXmas(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Xmas Stuff", "Success")
end)

V2:add_click_option("Valentines", "BS_RecoveryV2_VAL", function(option)
    v2r.unlockValentines(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Valentines", "Success")
end)

V2:add_click_option("Movie Props", "BS_RecoveryV2_MOV", function(option)
    v2r.unlockMovieProps(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Movie Props", "Success")
end)

V2:add_click_option("Pilot School", "BS_RecoveryV2_PLT", function(option)
    v2r.unlockPilotSchool(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Pilot School", "Success")
end)

V2:add_click_option("Property Access", "BS_RecoveryV2_PAC", function(option)
    v2r.unlockPropertyAccess(c)
    option:setTags({{"[Granted]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Grant Property Access", "Success")
end)

V2:add_click_option("Objectives", "BS_RecoveryV2_OCS", function(option)
    v2r.unlockObjectives(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Objectives", "Success")
end)

V2:add_separator("Vehicles", "BS_RecoveryV2_Stats")

V2:add_click_option("Shotaro", "BS_RecoveryV2_SHT", function(option)
    v2r.unlockShotaro(c)
    option:setTags({{"[Now Available]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Shotaro", "Success")
end)

V2:add_click_option("Armored Paragon", "BS_RecoveryV2_ARP", function(option)
    v2r.unlockArmoredParagon(c)
    option:setTags({{"[Now Available]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Armored Paragon", "Success")
end)

V2:add_separator("Stats", "BS_RecoveryV2_Stats")

V2:add_click_option("Awards", "BS_RecoveryV2_AWD", function(option)
    v2r.awards(c)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Unlock Awards", "Success")
end)

V2:add_click_option("Health", "BS_RecoveryV2_HLT", function(option)
    v2r.health(c)
    option:setTags({{"[Modified]", math.random(255), math.random(255), math.random(255)}})
    notify.success("Modify Health", "Switch session to apply")
end)

V2:add_choose_option("Permanent Musket", "BS_RecoveryV2_MUS", false, {"Give", "Remove"}, function (value, option)
    if option == 1 then
        v2r.giveMusket(c)
        option:setTags({{"[Given]", math.random(255), math.random(255), math.random(255)}})
        notify.success("Give Musket", "Success")
    else
        v2r.removeMusket(c)
        option:setTags({{"[Removed]", math.random(255), math.random(255), math.random(255)}})
        notify.success("Remove Musket", "Success")
    end
end)

V2:add_choose_option("Permanent Firework Launcher", "BS_RecoveryV2_FIR", false, {"Give", "Remove"}, function (value, option)
    if option == 1 then
        v2r.giveFirework(c)
        option:setTags({{"[Given]", math.random(255), math.random(255), math.random(255)}})
        notify.success("Give Firework Launcher", "Success")
    else
        v2r.removeFirework(c)
        option:setTags({{"[Removed]", math.random(255), math.random(255), math.random(255)}})
        notify.success("Remove Firework Launcher", "Success")
    end
end)
--11