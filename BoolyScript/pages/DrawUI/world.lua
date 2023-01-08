World = Submenu.add_static_submenu("World", "BS_World_Submenu")
Main:add_sub_option("World", "BS_World_SubOption", World)

World:add_bool_option("Blackout", "BS_World_Blackout", function(state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(false)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
end)

World:add_bool_option("Total blackout", "BS_World_TotalBlackout", function(state)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(state)
end)

World:add_click_option("Artillery strike at waypoint", "BS_World_ArtStrikeAtWP", function()
    task.createTask("artStrikeAtWp", 0.5, 20, function ()        
        local coords = features.getWaypointCoords()
        if not coords then
            return notify.warning("World", "Set a waypoint before.")
        end
        local a = math.random(-10, 10)
        local b = math.random(-10, 10)
        FIRE.ADD_EXPLOSION(coords.x+a, coords.y-b, coords.z, 34, 300.0, true, false, 1.0, false)
    end)
end)

World:add_bool_option("Riot mode", "BS_World_RiotMode", function(state)
	MISC.SET_RIOT_MODE_ENABLED(state)
end):setHint("Makes peds around crazy so they shoot everyone.")

World:add_choose_option("Gravity", "BS_World_Gravity", true, {"Normal", "Lowered", "Moon", "No gravity"}, function (pos)
    MISC.SET_GRAVITY_LEVEL(pos-2)
end)

local bodyguards = Submenu.add_static_submenu("Bodyguards", "BS_World_Bodyguards_Submenu") do
    local groups = {}
    local pedsSubmenus = {}
    local spawnedBodyguards = {}
    local weapons = {
        ["None"] = 2725352035,
        ["Pistol"] = 453432689, 
        ["AK-74"] = 3220176749, 
        ["M4"] = 2210333304, 
        ["M16"] = 3520460075, 
        ["MG"] = 2634544996, 
        ["Shotgun"] = 487013001, 
        ["RPG"] = 2982836145, 
    }
    local config = {
        godmode = false,
        weapon = weapons["None"],
        formation = 0,
        ignorePlayers = false,
    }
    local search = Submenu.add_static_submenu("Search", "BS_World_Bodyguards_Search_Submenu") do
        local options = {}
        local name = search:add_text_input("Name/Hash", "BS_World_Bodyguards_Search_Name")
        search:add_click_option("Find", "BS_World_Bodyguards_Search_Find", function ()
            if name:getValue() == "" then return notify.warning("Bodyguards", "Enter ped's name/hash before.") end
            notify.important("Bodyguards", "Searching for the results...")
            local request = tostring(name:getValue())
            for _, option in ipairs(options) do
                option:remove()
            end
            options = {}
            for _, t in ipairs(pedsSubmenus) do
                if string.find(string.lower(t.name), string.lower(request)) or t.hash == tonumber(request) then
                    table.insert(options, search:add_sub_option(t.name, "BS_World_Bodyguards_SearchResults" .. t.name, t.sub))
                end
            end
            if #options > 0 then
                notify.success("Bodyguards", string.format("Found %i results.", #options))
            else
                notify.fatal("Bodyguards", "Unfortunately, nothing was found..")
            end
        end)
        search:add_separator("Results", "BS_World_Bodyguards_Search_Results")
        bodyguards:add_sub_option("Search", "BS_World_Bodyguards_Search_SubOption", search)
    end
    local settings = Submenu.add_static_submenu("Settings", "BS_World_Bodyguards_Settings_Submenu") do
        settings:add_bool_option("Invincibility", "BS_World_Bodyguards_Settings_Godmode", function (state)
            config.godmode = state
        end)
        local variations = {"None", "Pistol", "AK-74", "M4", "M16", "MG", "Shotgun", "RPG"}
        settings:add_choose_option("Weapon", "BS_World_Bodyguards_Settings_Weapons", true, variations, function (pos)
            config.weapon = weapons[variations[pos]]
        end)
        settings:add_choose_option("Formation", "BS_World_Bodyguards_Settings_Formation", true, {"Default", "Circle Around Leader", "Alt. Circle Around Leader", "Line, with Leader at center"}, function (pos)
            config.formation = pos - 1
        end)
        settings:add_bool_option("Ignore players", "BS_World_Bodyguards_Settings_IgnorePlayers", function (state)
            config.ignorePlayers = state
        end)
        settings:add_separator("All bodyguards", "BS_World_Bodyguards_Settings_All")
        settings:add_click_option("Teleport to me", "BS_World_Bodyguards_Settings_TpToMe", function ()
            for ped, _ in pairs(spawnedBodyguards) do
                local ped = tonumber(ped)
                local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), math.random(-5, 5), math.random(-5, 5), 0)
                ENTITY.SET_ENTITY_COORDS(ped, coords.x, coords.y, coords.z, false, false, false, false)
            end
        end)
        settings:add_click_option("Update", "BS_World_Bodyguards_Settings_Update", function ()
            for ped, _ in pairs(spawnedBodyguards) do
                local ped = tonumber(ped)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, config.godmode)
                ENTITY.SET_ENTITY_PROOFS(ped, config.godmode, config.godmode, config.godmode, config.godmode, config.godmode, config.godmode, true, config.godmode)
                WEAPON.GIVE_WEAPON_TO_PED(ped, config.weapon, -1, false, true)
                WEAPON.SET_CURRENT_PED_WEAPON(ped, config.weapon, false)
                local group
                if PED.IS_PED_IN_GROUP(PLAYER.PLAYER_PED_ID()) then
                    group = PED.GET_PED_GROUP_INDEX(PLAYER.PLAYER_PED_ID())
                else
                    group = PED.CREATE_GROUP(0)
                    PED.SET_PED_AS_GROUP_LEADER(PLAYER.PLAYER_PED_ID(), group)
                end
                PED.SET_PED_AS_GROUP_MEMBER(ped, group)
                PED.SET_GROUP_FORMATION_SPACING(group, 1.0, 0.9, 3.0)
                PED.SET_GROUP_SEPARATION_RANGE(group, 200.0)
                PED.SET_GROUP_FORMATION(group, config.formation)
                if config.ignorePlayers then
                    PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID()))
                end
            end
        end):setHint("Applies all settings above for all spawned\nbodyguards.")
        settings:add_click_option("Remove", "BS_World_Bodyguards_Settings_Remove", function ()
            for ped, t in pairs(spawnedBodyguards) do
                local ped = tonumber(ped)
                entity.delete(ped)
                t[1]:remove()
                t[2]:remove()
            end
            spawnedBodyguards = {}
        end)
        bodyguards:add_sub_option("Settings", "BS_World_Bodyguards_Settings_Submenu", settings)
    end
    local spawned = Submenu.add_static_submenu("Spawned bodyguards", "BS_World_Bodyguards_Spawned_Submenu") do
        bodyguards:add_sub_option("Spawned bodyguards", "BS_World_Bodyguards_Spawned_SubOption", spawned)
    end
    bodyguards:add_separator("Categories", "BS_World_Bodyguards_Categories")
    local pedTypes = {
        ["Animal"] = "Animal",
        ["civmale"] = "Civilian male",
        ["CIVFEMALE"] = "Civilian female",
        ["COP"] = "Cop",
        ["PLAYER_1"] = "Franklin",
        ["PLAYER_2"] = "Trevor",
        ["PLAYER_0"] = "Michael",
        ["army"] = "Army",
        ["MEDIC"] = "Medical",
        ["FIREMAN"] = "Fireman",
        ["Swat"] = "SWAT",
    }
    for _, pedInfo in ipairs(ParsedFiles.peds) do
        if not groups[pedInfo["type"]] then 
            local sub = Submenu.add_static_submenu(pedTypes[pedInfo["type"]] or "Unsorted", "BS_World_Bodyguards_" .. pedInfo["type"] .. "_Submenu")
            bodyguards:add_sub_option(pedTypes[pedInfo["type"]] or "Unsorted", "BS_World_Bodyguards_" .. pedInfo["type"] .. "_SubOption", sub)
            groups[pedInfo["type"]] = sub 
        end
        local submenu = groups[pedInfo["type"]] do
            local sub = Submenu.add_static_submenu(pedInfo["name"], "BS_World_Bodyguards_" .. pedInfo["name"] .. "_Submenu") do                
                sub:add_click_option("Spawn",  "BS_World_Bodyguards_" .. pedInfo["name"] .. "_Spawn", function ()
                    entity.spawn_ped(pedInfo["hash"], function (ped)
                        PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
                        PED.SET_PED_SEEING_RANGE(ped, 100.0)
                        PED.SET_PED_CONFIG_FLAG(ped, 208, true)
                        WEAPON.GIVE_WEAPON_TO_PED(ped, config.weapon, -1, false, true)
                        WEAPON.SET_CURRENT_PED_WEAPON(ped, config.weapon, false)
                        PED.SET_PED_FIRING_PATTERN(ped, 0xC6EE6B4C)
                        PED.SET_PED_SHOOT_RATE(ped, 100.0)
                        ENTITY.SET_ENTITY_INVINCIBLE(ped, config.godmode)
                        ENTITY.SET_ENTITY_PROOFS(ped, config.godmode, config.godmode, config.godmode, config.godmode, config.godmode, config.godmode, true, config.godmode)
                        local group
                        if PED.IS_PED_IN_GROUP(PLAYER.PLAYER_PED_ID()) then
                            group = PED.GET_PED_GROUP_INDEX(PLAYER.PLAYER_PED_ID())
                        else
                            group = PED.CREATE_GROUP(0)
                            PED.SET_PED_AS_GROUP_LEADER(PLAYER.PLAYER_PED_ID(), group)
                        end
                        PED.SET_PED_AS_GROUP_MEMBER(ped, group)
                        PED.SET_GROUP_FORMATION_SPACING(group, 1.0, 0.9, 3.0)
                        PED.SET_GROUP_SEPARATION_RANGE(group, 200.0)
                        PED.SET_GROUP_FORMATION(group, config.formation)
                        if config.ignorePlayers then
                            PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID()))
                        end
                        local name = string.format("%s (%i)", pedInfo["name"], ped)
                        local sub = Submenu.add_static_submenu(name, "BS_World_Bodyguards_" .. name .. "_Spawned_Submenu") do
                            sub:add_click_option("Teleport to me", "BS_World_Bodyguards_" .. name .. "_Spawned_TpToMe", function ()
                                local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), math.random(-5, 5), math.random(-5, 5), 0)
                                ENTITY.SET_ENTITY_COORDS(ped, coords.x, coords.y, coords.z, false, false, false, false)
                            end)
                            sub:add_choose_option("Set invincible", "BS_World_Bodyguards_" .. name .. "_Spawned_GodMode", false, {"Set", "Remove"}, function (pos, option)
                                ENTITY.SET_ENTITY_INVINCIBLE(ped, pos == 1)
                                option:setValue((pos == 1) and 2 or 1, true)
                            end)
                            local variations = {"None", "Pistol", "AK-74", "M4", "M16", "MG", "Shotgun", "RPG"}
                            sub:add_choose_option("Weapon",  "BS_World_Bodyguards_" .. name .. "_Spawned_Weapons", false, variations, function (pos)
                                WEAPON.GIVE_WEAPON_TO_PED(ped, weapons[variations[pos]], -1, false, true)
                                WEAPON.SET_CURRENT_PED_WEAPON(ped, weapons[variations[pos]], false)
                            end)
                            local subOption = spawned:add_sub_option(name, "BS_World_Bodyguards_" .. name .. "_Spawned_SubOption", sub)
                            sub:add_click_option("Remove", "BS_World_Bodyguards_" .. name .. "_Spawned_Remove", function ()
                                entity.delete(ped)
                                subOption:remove()
                                sub:remove()
                                spawnedBodyguards[tostring(ped)] = nil
                            end)
                            spawnedBodyguards[tostring(ped)] = {sub, subOption}
                        end
                    end)
                end)
                table.insert(pedsSubmenus, {
                    name = pedInfo["name"],
                    hash = pedInfo["hash"],
                    sub = sub,
                })
                submenu:add_sub_option(pedInfo["name"], "BS_World_Bodyguards_" .. pedInfo["name"] .. "_SubOption", sub)
            end
        end
    end
    World:add_sub_option("Bodyguards", "BS_World_Bodyguards_SubOption", bodyguards)
end

World:add_separator("Area cleanup", "BS_World_AreaCleanup")
local cleanupRadius

World:add_looped_option("Peds cleanup", "BS_World_PedsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = cleanupRadius:getValue() + .0
    
    MISC.CLEAR_AREA_OF_PEDS(coords.x, coords.y, coords.z, radius, 0)
end)

World:add_looped_option("Vehicles cleanup", "BS_World_VehiclesCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = cleanupRadius:getValue() + .0

    MISC.CLEAR_AREA_OF_VEHICLES(coords.x, coords.y, coords.z, radius, false, false, false, false, false, 0)
end)

World:add_looped_option("Cops cleanup", "BS_World_CopsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = cleanupRadius:getValue() + .0

    MISC.CLEAR_AREA_OF_COPS(coords.x, coords.y, coords.z, radius, 0)
end)

World:add_looped_option("Objects cleanup", "BS_World_ObjectsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = cleanupRadius:getValue() + .0

    MISC.CLEAR_AREA_OF_OBJECTS(coords.x, coords.y, coords.z, radius, 0)
end)

World:add_looped_option("Projectiles cleanup", "BS_World_ProjCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = cleanupRadius:getValue() + .0

    MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, radius, 0)
end)

cleanupRadius = World:add_num_option("Cleanup radius", "BS_World_CleanupRadius", 0, 600, 100):setValue(300)