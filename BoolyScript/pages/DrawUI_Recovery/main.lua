v2r = require("BoolyScript/pages/DrawUI_Recovery/include")

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

V2:add_separator("Unlocks", "BS_RecoveryV2_Unlocks")


local unlockOptions = ordered_table.new{
    "Extra", v2r.unlockExtra,
    "Clothes", v2r.unlockClothes,
    "Rockstar Clothes", v2r.unlockAdminStuff,
    "Tattoos", v2r.unlockTattoos,
    "Weapons", v2r.unlockWeapons,
    "Exclusive Content", v2r.unlockExclusiveContent,
    "Challenges", v2r.unlockChallenges,
    "Fast Run + Reload", v2r.unlockFastRunPlusReload,
    "Vehicle Mods", v2r.unlockVehicleMods,
    "Xmas Stuff", v2r.unlockXmas,
    "Valentines", v2r.unlockValentines,
    "Movie Props", v2r.unlockMovieProps,
    "Pilot School", v2r.unlockPilotSchool,
    "Property Access", v2r.unlockPropertyAccess,
    "Objectives", v2r.unlockObjectives
}


for name, func in pairs(unlockOptions) do
    V2:add_click_option(name, "BS_RecoveryV2_Unlocks_" .. name, function(option)
        func(c)
        option:setTags({{"[Unlocked]", 10, 245, 18}})
        notify.success("Unlock " .. name, "Success")
    end)
end

V2:add_separator("Vehicles", "BS_RecoveryV2_Vehicles")

local unlockVehs = ordered_table.new{
    "Shotaro", v2r.unlockShotaro,
    "Armored Paragon", v2r.unlockArmoredParagon
}

for name, func in pairs(unlockVehs) do
    V2:add_click_option(name, "BS_RecoveryV2_Vehicles_" .. name, function(option)
        func(c)
        option:setTags({{"[Now Available]", 210, 255, 48}})
        notify.success("Unlock " .. name, "Success")
    end)
end

V2:add_separator("Stats", "BS_RecoveryV2_Stats")

local unlockStats = ordered_table.new{
    "Awards", v2r.awards,
    "Health", v2r.health
}

for name, func in pairs(unlockStats) do
    V2:add_click_option(name, "BS_RecoveryV2_Stats_" .. name, function(option)
        func(c)
        option:setTags({{"[Unlocked]", 247, 72, 171}})
        notify.success("Unlock " .. name, "Success")
    end)
end

--[[V2:add_choose_option("Permanent Musket", "BS_RecoveryV2_MUS", false, {"Give", "Remove"}, function (value, option)
    if value == 1 then
        v2r.giveMusket(c)
        option:setTags({{"[Given]", 70, 234, 242}})
        notify.success("Give Musket", "Success")
    else
        v2r.removeMusket(c)
        option:setTags({{"[Removed]", 245, 26, 10}})
        notify.success("Remove Musket", "Success")
    end
end)]]

V2:add_choose_option("Permanent Firework Launcher", "BS_RecoveryV2_FIR", false, {"Give", "Remove"}, function (value, option)
    if value == 1 then
        v2r.giveFirework(c)
        option:setTags({{"[Given]", 70, 234, 242}})
        notify.success("Give Firework Launcher", "Success")
    else
        v2r.removeFirework(c)
        option:setTags({{"[Removed]", 245, 26, 10}})
        notify.success("Remove Firework Launcher", "Success")
    end
end)