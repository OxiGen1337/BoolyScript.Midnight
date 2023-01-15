World = Submenu.add_static_submenu("World", "BS_World")
Main:add_sub_option("World", "BS_World", World)

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

local bodyguards = Submenu.add_static_submenu("Bodyguards", "BS_World_Bodyguards") do
    local groups = {}
    local pedsOptions = {}
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
    local search = Submenu.add_static_submenu("Search", "BS_World_Bodyguards_Search") do
        local options = {}
        local name = search:add_text_input("Name/Hash", "BS_World_Bodyguards_Search_Name"):setConfigIgnore()
        search:add_click_option("Find", "BS_World_Bodyguards_Search_Find", function ()
            if name:getValue() == "" then return notify.warning("Bodyguards", "Enter ped's name/hash before.") end
            notify.important("Bodyguards", "Searching for the results...")
            local request = tostring(name:getValue())
            for _, option in ipairs(options) do
                option:remove()
            end
            options = {}
            for _, t in ipairs(pedsOptions) do
                if string.find(string.lower(t.name), string.lower(request)) or t.hash == tonumber(request) then
                    table.insert(options, search:add_click_option(t.name, "BS_World_Bodyguards_SearchResults" .. t.name, function ()
                        t.option.callback()
                    end):setTranslationIgnore())
                end
            end
            if #options > 0 then
                notify.success("Bodyguards", string.format("Found %i results.", #options))
            else
                notify.fatal("Bodyguards", "Unfortunately, nothing was found..")
            end
        end)
        search:add_separator("Results", "BS_World_Bodyguards_Search_Results")
        bodyguards:add_sub_option("Search", "BS_World_Bodyguards_Search", search)
    end
    local settings = Submenu.add_static_submenu("Settings", "BS_World_Bodyguards_Settings") do
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
            for ped, _ in pairs(Stuff.bodyguards) do
                local ped = tonumber(ped)
                local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), math.random(-5, 5), math.random(-5, 5), 0)
                ENTITY.SET_ENTITY_COORDS(ped, coords.x, coords.y, coords.z, false, false, false, false)
            end
        end)
        settings:add_click_option("Update", "BS_World_Bodyguards_Settings_Update", function ()
            for ped, _ in pairs(Stuff.bodyguards) do
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
            for ped, t in pairs(Stuff.bodyguards) do
                local ped = tonumber(ped)
                entity.delete(ped)
                t[1]:remove()
                t[2]:remove()
            end
            Stuff.bodyguards = {}
        end)
        bodyguards:add_sub_option("Settings", "BS_World_Bodyguards_Settings", settings)
    end
    local spawned = Submenu.add_static_submenu("Spawned bodyguards", "BS_World_Bodyguards_Spawned") do
        bodyguards:add_sub_option("Spawned bodyguards", "BS_World_Bodyguards_Spawned", spawned)
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
            local sub = Submenu.add_static_submenu(pedTypes[pedInfo["type"]] or "Unsorted", "BS_World_Bodyguards_" .. pedInfo["type"] .. "")
            bodyguards:add_sub_option(pedTypes[pedInfo["type"]] or "Unsorted", "BS_World_Bodyguards_" .. pedInfo["type"] .. "", sub)
            groups[pedInfo["type"]] = sub 
        end
        local submenu = groups[pedInfo["type"]] do
            local option = submenu:add_click_option(pedInfo["name"], "BS_World_Bodyguards_" .. pedInfo["name"] .. "_Spawn", function ()
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
                    local sub = Submenu.add_static_submenu(name, "BS_World_Bodyguards_" .. name .. "_Spawned"):setTranslationIgnore() do
                        sub:add_click_option("Teleport to me", "BS_World_Bodyguards_Spawned_TpToMe", function ()
                            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), math.random(-5, 5), math.random(-5, 5), 0)
                            ENTITY.SET_ENTITY_COORDS(ped, coords.x, coords.y, coords.z, false, false, false, false)
                        end)
                        sub:add_choose_option("Set invincible", "BS_World_Bodyguards_Spawned_GodMode", false, {"Set", "Remove"}, function (pos, option)
                            ENTITY.SET_ENTITY_INVINCIBLE(ped, pos == 1)
                            option:setValue((pos == 1) and 2 or 1, true)
                        end):setConfigIgnore()
                        local variations = {"None", "Pistol", "AK-74", "M4", "M16", "MG", "Shotgun", "RPG"}
                        sub:add_choose_option("Weapon",  "BS_World_Bodyguards_Spawned_Weapons", false, variations, function (pos)
                            WEAPON.GIVE_WEAPON_TO_PED(ped, weapons[variations[pos]], -1, false, true)
                            WEAPON.SET_CURRENT_PED_WEAPON(ped, weapons[variations[pos]], false)
                        end)
                        local subOption = spawned:add_sub_option(name, "BS_World_Bodyguards_Spawned", sub)
                        sub:add_click_option("Remove", "BS_World_Bodyguards_Spawned_Remove", function ()
                            entity.delete(ped)
                            subOption:remove()
                            sub:remove()
                            Stuff.bodyguards[tostring(ped)] = nil
                        end)
                        Stuff.bodyguards[tostring(ped)] = {sub, subOption}
                        local taskName = "BS_World_Bodyguards"
                        if not task.exists(taskName) then 
                            task.createTask(taskName, 0.0, nil, function ()
                                for ped_s, t in pairs(Stuff.bodyguards) do
                                    local ped = tonumber(ped_s)
                                    if ENTITY.GET_ENTITY_HEALTH(ped) <= 100 then
                                        if ENTITY.DOES_ENTITY_EXIST(ped) then
                                            entity.delete(ped)
                                        end
                                        t[1]:remove()
                                        t[2]:remove()
                                        Stuff.bodyguards[ped_s] = nil
                                    elseif not ENTITY.DOES_ENTITY_EXIST(ped) then
                                        t[1]:remove()
                                        t[2]:remove()
                                        Stuff.bodyguards[ped_s] = nil
                                    end
                                end
                            end)
                        end
                    end
                end)
            end):setHint("Click to spawn."):setTranslationIgnore()
            table.insert(pedsOptions, {
                name = pedInfo["name"],
                hash = pedInfo["hash"],
                option = option,
            })
        end
    end
    World:add_sub_option("Bodyguards", "BS_World_Bodyguards", bodyguards)
end

local objects = Submenu.add_static_submenu("Objects", "BS_World_Objects") do
    local spawnedObjects = {}
    local search = Submenu.add_static_submenu("Search", "BS_World_Objects_Search") do
        local options = {}
        local name = search:add_text_input("Name/Hash", "BS_World_Objects_Search_Name"):setConfigIgnore()
        search:add_click_option("Find", "BS_World_Objects_Search_Find", function ()
            if name:getValue() == "" then return notify.warning("Objects", "Enter object's name/hash before.") end
            notify.important("Objects", "Searching for the results...")
            local request = tostring(name:getValue())
            for _, option in ipairs(options) do
                option:remove()
            end
            options = {}
            for _, object in ipairs(ParsedFiles.objects) do
                local hash = string.joaat(object)
                if string.find(string.lower(object), string.lower(request)) or hash == tonumber(request) then
                    table.insert(options, search:add_click_option(object, "BS_World_Objects_Search_Results_" .. object, function ()
                        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player.id(), 0.0, 7.5, 0.0)
                        entity.spawn_obj(hash, coords, function (hdl)
                            local netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(hdl)
                            table.insert(spawnedObjects, {object, netID})
                            local rot = ENTITY.GET_ENTITY_ROTATION(player.id(), 5)
                            ENTITY.SET_ENTITY_ROTATION(hdl, rot.x, rot.y, rot.z, 5, true)
                        end)
                    end):setHint("Click to spawn."):setTranslationIgnore())
                end
            end
            if #options > 0 then
                notify.success("Objects", string.format("Found %i results.", #options))
            else
                notify.fatal("Objects", "Unfortunately, nothing was found..")
            end
        end)
        search:add_separator("Results", "BS_World_Objects_Search_Results")
        objects:add_sub_option("Search", "BS_World_Objects_Search", search)
    end
    local selectedObject = nil
    local spawnedObjectEditor = Submenu.add_static_submenu("Editor", "BS_World_Objects_Spawned_Editor") do
        spawnedObjectEditor:add_click_option("Remove", "BS_World_Objects_Spawned_Editor_Remove", function ()
            if not selectedObject then return end
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            entity.delete(hdl)
            spawnedObjectEditor:setActive(false)
        end)
        spawnedObjectEditor:add_separator("Physics", "BS_World_Objects_Spawned_Physics")
        spawnedObjectEditor:add_choose_option("Gravity", "BS_World_Objects_Spawned_Physics_Gravity", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.SET_ENTITY_HAS_GRAVITY(hdl, pos == 1)
        end)
        spawnedObjectEditor:add_choose_option("Freeze", "BS_World_Objects_Spawned_Physics_Freeze", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.FREEZE_ENTITY_POSITION(hdl, pos == 1)
        end)
        spawnedObjectEditor:add_choose_option("Collision [Raw]", "BS_World_Objects_Spawned_Physics_CollisionRaw", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.SET_ENTITY_COLLISION(hdl, pos == 1, false)
        end)        
        spawnedObjectEditor:add_choose_option("Collision [Keep physics]", "BS_World_Objects_Spawned_Physics_CollisionPhys", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.SET_ENTITY_COLLISION(hdl, pos == 1, true)
        end)
        spawnedObjectEditor:add_choose_option("Invincibility", "BS_World_Objects_Spawned_Physics_Invincibility", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.SET_ENTITY_INVINCIBLE(hdl, pos == 1)
        end)
        spawnedObjectEditor:add_choose_option("Visibility", "BS_World_Objects_Spawned_Physics_Visibility", false, {"ON", "OFF"}, function (pos)
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            ENTITY.SET_ENTITY_VISIBLE(hdl, pos == 1, false)
        end)
        spawnedObjectEditor:add_separator("Position", "BS_World_Objects_Spawned_Position")
        local posStep = spawnedObjectEditor:add_float_option("Step", "BS_World_Objects_Spawned_Editor_Position_Step", 0.1, 30.0, 0.1):setValue(1.0)
        spawnedObjectEditor:add_choose_option("Move [X]", "BS_World_Objects_Spawned_Editor_Position_X", false, {"[+]", "[-]"}, function (pos)
            local step = posStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(hdl, step, 0.0, 0.0)
            utils.teleport(hdl, coords)
        end)
        spawnedObjectEditor:add_choose_option("Move [Y]", "BS_World_Objects_Spawned_Editor_Position_Y", false, {"[+]", "[-]"}, function (pos)
            local step = posStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(hdl, 0.0, step, 0.0)
            utils.teleport(hdl, coords)
        end)        
        spawnedObjectEditor:add_choose_option("Move [Z]", "BS_World_Objects_Spawned_Editor_Position_Z", false, {"[+]", "[-]"}, function (pos)
            local step = posStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(hdl, 0.0, 0.0, step)
            utils.teleport(hdl, coords)
        end)
        spawnedObjectEditor:add_separator("Rotation", "BS_World_Objects_Spawned_Rotation")
        local rotStep = spawnedObjectEditor:add_float_option("Step", "BS_World_Objects_Spawned_Editor_Rotation_Step", 0.1, 30.0, 0.1):setValue(1.0)
        spawnedObjectEditor:add_choose_option("Rotate [Pitch]", "BS_World_Objects_Spawned_Editor_Rotation_X", false, {"[+]", "[-]"}, function (pos)
            local step = rotStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local rot = ENTITY.GET_ENTITY_ROTATION(hdl, 5)
            rot.x = rot.x + step
            ENTITY.SET_ENTITY_ROTATION(hdl, rot.x, rot.y, rot.z, 5, true)
        end)
        spawnedObjectEditor:add_choose_option("Rotate [Roll]", "BS_World_Objects_Spawned_Editor_Rotation_Y", false, {"[+]", "[-]"}, function (pos)
            local step = rotStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local rot = ENTITY.GET_ENTITY_ROTATION(hdl, 5)
            rot.y = rot.y + step
            ENTITY.SET_ENTITY_ROTATION(hdl, rot.x, rot.y, rot.z, 5, true)
        end)        
        spawnedObjectEditor:add_choose_option("Rotate [Yaw]", "BS_World_Objects_Spawned_Editor_Rotation_Z", false, {"[+]", "[-]"}, function (pos)
            local step = rotStep:getValue()
            step = pos == 1 and step or -step
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(selectedObject)
            local rot = ENTITY.GET_ENTITY_ROTATION(hdl, 5)
            rot.z = rot.z + step
            ENTITY.SET_ENTITY_ROTATION(hdl, rot.x, rot.y, rot.z, 5, true)
        end)
    end
    local spawned = Submenu.add_dynamic_submenu("Spawned", "BS_World_Objects_Spawned", function (spawned)
        for _, object in ipairs(spawnedObjects) do
            local name = string.format("%s (ID: %i)", object[1], object[2])
            spawned:add_sub_option(name, "BS_World_Objects_Spawned_" .. name, spawnedObjectEditor, function ()
                selectedObject = object[2]
            end)
        end
    end)
    objects:add_sub_option("Spawned", "BS_World_Objects_Spawned", spawned)
    task.createTask("BS_World_Objects_Spawned", 0.0, nil, function ()
        for ID, object in ipairs(spawnedObjects) do
            local hdl = NETWORK.NETWORK_GET_ENTITY_FROM_NETWORK_ID(object[2])
            if not ENTITY.DOES_ENTITY_EXIST(hdl) then
                table.remove(spawnedObjects, ID)
            end
        end
    end)      
    World:add_sub_option("Objects", "BS_World_Objects", objects)
end

World:add_separator("Area cleanup", "BS_World_AreaCleanup")

local cleanupRadius = World:add_num_option("Cleanup radius", "BS_World_CleanupRadius", 0, 600, 100):setValue(300)

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
