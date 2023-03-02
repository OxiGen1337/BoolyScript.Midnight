v2r = require("BoolyScript/pages/DrawUI/v2/include")

local character = script_global:new(1574918):get_long()

V2:add_click_option("Nightclub Scam", "BS_RecoveryV2_Nightclub_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. character .."_PROP_NIGHTCLUB_VALUE"), 2004500000)
    option:setTags({{"[Done]", math.random(255), math.random(255), math.random(255)}})
end):setHint("Step 1: Purchase a Nightclub\nStep 2: Activate this option\nStep 3: Purchase another Nightclub and replace it")

V2:add_click_option("Hangar Scam", "BS_RecoveryV2_Hangar_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. character .."_PROP_HANGAR_VALUE"), 2004500000)
    option:setTags({{"[Done]", math.random(255), math.random(255), math.random(255)}})
end):setHint("Step 1: Purchase a Hangar\nStep 2: Activate this option\nStep 3: Purchase another Hangar and replace it")

V2:add_click_option("Clubhouse Scam", "BS_RecoveryV2_Clubhouse_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. character .."_PROP_CLUBHOUSE_VALUE"), 2004500000)
    option:setTags({{"[Done]", math.random(255), math.random(255), math.random(255)}})
end):setHint("Step 1: Purchase a Clubhouse Scam\nStep 2: Activate this option\nStep 3: Purchase another Clubhouse Scam and replace it")

V2:add_click_option("Auto Shop Scam", "BS_RecoveryV2_AS_Scam", function(option)
    stats.set_u64(string.joaat("MP" .. character .."_PROP_AUTO_SHOP_VALUE"), 2004500000)
    option:setTags({{"[Done]", math.random(255), math.random(255), math.random(255)}})
end):setHint("Step 1: Purchase an Auto Shop\nStep 2: Activate this option\nStep 3: Purchase another Auto Shop and replace it")

V2:add_separator("Unlocks", "BS_RecoveryV2_Unl")

V2:add_click_option("Extra", "BS_RecoveryV2_Extra", function(option)
    v2r.unlockExtra(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Regular Clothes", "BS_RecoveryV2_CL", function(option)
    v2r.unlockClothes(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Rockstar Clothes", "BS_RecoveryV2_RCL", function(option)
    v2r.unlockAdminStuff(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Tattoos", "BS_RecoveryV2_TT", function(option)
    v2r.unlockTattoos(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Weapons", "BS_RecoveryV2_WP", function(option)
    v2r.unlockWeapons(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Exclusive Content", "BS_RecoveryV2_EC", function(option)
    v2r.unlockExclusiveContent()
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Challenges", "BS_RecoveryV2_CLL", function(option)
    v2r.unlockChallenges()
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Fast Run + Reload", "BS_RecoveryV2_FRR", function(option)
    v2r.unlockFastRunPlusReload(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Vehicle Mods", "BS_RecoveryV2_VM", function(option)
    v2r.unlockVehicleMods(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Xmas Stuff", "BS_RecoveryV2_XMAS", function(option)
    v2r.unlockXmas(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Valentines", "BS_RecoveryV2_VAL", function(option)
    v2r.unlockValentines(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Movie Props", "BS_RecoveryV2_MOV", function(option)
    v2r.unlockMovieProps(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Pilot School", "BS_RecoveryV2_PLT", function(option)
    v2r.unlockPilotSchool(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Property Access", "BS_RecoveryV2_PAC", function(option)
    v2r.unlockPropertyAccess(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Objectives", "BS_RecoveryV2_OCS", function(option)
    v2r.unlockObjectives(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_separator("Vehicles", "BS_RecoveryV2_Stats")

V2:add_click_option("Shotaro", "BS_RecoveryV2_SHT", function(option)
    v2r.unlockShotaro(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Armored Paragon", "BS_RecoveryV2_ARP", function(option)
    v2r.unlockArmoredParagon(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_separator("Stats", "BS_RecoveryV2_Stats")

V2:add_click_option("Awards", "BS_RecoveryV2_AWD", function(option)
    v2r.awards(character)
    option:setTags({{"[Unlocked]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Health", "BS_RecoveryV2_HLT", function(option)
    v2r.health(character)
    option:setTags({{"[Applied]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Musket", "BS_RecoveryV2_MUS", function(option)
    v2r.giveMusket(character)
    option:setTags({{"[Given]", math.random(255), math.random(255), math.random(255)}})
end)

V2:add_click_option("Firework", "BS_RecoveryV2_FIR", function(option)
    v2r.giveFirework(character)
    option:setTags({{"[Given]", math.random(255), math.random(255), math.random(255)}})
end)
