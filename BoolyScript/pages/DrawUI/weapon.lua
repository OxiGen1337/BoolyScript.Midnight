Weapon = Submenu.add_static_submenu("Weapon", "BS_Weapon_Submenu")
Main:add_sub_option("Weapon", "BS_Weapon_SubOption", Weapon)

local blWepCategories = {["GROUP_DIGISCANNER"] = false, ["GROUP_NIGHTVISION"] = false, ["GROUP_TRANQILIZER"] = false}

local Ammunation = Submenu.add_static_submenu("Ammunation", "BS_Weapon_Ammunation_Submenu") do
    task.executeAsScript("BS_PresetsMgr_LoadAmmunation", function ()
        if not filesys.doesFileExist(paths.files.weapons) then return end
        local ped = PLAYER.PLAYER_PED_ID()
        local createdCateg = {}
        local createdWepSubs = {}
        for _, wepInfo in ipairs(ParsedFiles.weapons) do
            if 
            not features.isEmpty(wepInfo['Category']) 
            and features.isEmpty(blWepCategories[wepInfo['Category']])
            and not features.isEmpty(wepInfo['TranslatedLabel']) 
            and not features.isEmpty(wepInfo['TranslatedLabel']['Name'])
            and wepInfo['TranslatedLabel']['Name'] ~= 'WT_INVALID'
            and not features.isEmpty(wepInfo['Tints'])
            then
                local category = tostring(wepInfo["Category"])
                local wepName = wepInfo['TranslatedLabel']['Name']
                local wepHash = wepInfo['Hash']
                local wepComponents = {}
                if wepInfo['Components'] then wepComponents = wepInfo['Components'] end
                if not createdCateg[category] then
                    local hash = "BS_Weapon_Ammunation_" .. category
                    local name = features.makeFirstLetUpper((category:gsub('GROUP_', '')):lower())
                    local sub = Submenu.add_static_submenu(name, hash .. "_Submenu")
                    Ammunation:add_sub_option(name, hash .. "_SubOption", sub)
                    createdCateg[category] = sub
                end
                do
                    local hash = "BS_Weapon_Ammunation_" .. category .. "_" .. wepName
                    local name = HUD._GET_LABEL_TEXT(wepName)
                    local sub = Submenu.add_static_submenu(name, hash .. "_Submenu")
                    createdCateg[category]:add_sub_option(name, hash .. "_SubOption", sub)
                    createdWepSubs[wepName] = sub
                end
                local weaponSub = createdWepSubs[wepName]
                weaponSub:add_choose_option("Manage", "BS_Weapon_Ammunation_" .. category .. "_" .. wepName .. "_Manage", false, {"Give", "Remove"}, function(pos, option)
                    if pos == 1 then
                        WEAPON.GIVE_WEAPON_TO_PED(ped, wepHash, 1000, false, true)
                        option:setValue(2, true)
                    else
                        WEAPON.REMOVE_WEAPON_FROM_PED(ped, wepHash)
                        option:setValue(1, true)
                    end
                end):setConfigIgnore()
                if #wepComponents > 0 then
                    weaponSub:add_separator("Components", "BS_Weapon_Ammunation_" .. category .. "_" .. wepName .. "_Components")
                end
                for _, componentInfo in ipairs(wepComponents) do
                    local name = string.format("Untitled [%s]", componentInfo["Hash"])
                    if componentInfo['TranslatedLabel'] then 
                        if componentInfo['TranslatedLabel']['Name'] then
                            name = HUD._GET_LABEL_TEXT(componentInfo['TranslatedLabel']['Name'])
                        end
                    end
                    weaponSub:add_choose_option(name, "BS_Weapon_Ammunation_" .. category .. "_" .. wepName .. "_ComponentManage", false, {"Add", "Remove"}, function(pos, option)
                        if pos == 1 then
                            WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(PLAYER.PLAYER_PED_ID(), wepHash, componentInfo['Hash'])
                            option:setValue(2, true)
                        else
                            WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(ped, wepHash, componentInfo['Hash'])
                            option:setValue(1, true)
                        end
                    end):setConfigIgnore()
                end
                local wepTints = {}
                if wepInfo['Tints'] then wepTints = wepInfo['Tints'] end
                if #wepTints > 0 then
                    weaponSub:add_separator("Tints", "BS_Weapon_Ammunation_" .. category .. "_" .. wepName .. "_Tints")
                end
                for _, tintInfo in ipairs(wepTints) do
                    local name = string.format("Untitled [%s]", tintInfo["Index"])
                    if tintInfo['TranslatedLabel'] then 
                        if tostring(tintInfo['TranslatedLabel']['Name']) ~= "NULL" then
                            name = HUD._GET_LABEL_TEXT(tintInfo['TranslatedLabel']['Name'])
                        end
                    end
                    weaponSub:add_click_option(name,  "BS_Weapon_Ammunation_" .. category .. "_" .. wepName .. "_Tints_" .. name, function()
                        WEAPON.SET_PED_WEAPON_TINT_INDEX(ped, wepInfo['Hash'], tintInfo['Index'])
                    end):setConfigIgnore()
                end
            end
        end
    end)
    Weapon:add_sub_option("Ammunation", "BS_Weapon_Ammunation_SubOption", Ammunation)
end

Weapon:add_looped_option("Dead eye effect", "BS_Weapon_DeadEye", 0.0, function ()
    local effect = "BulletTime"
    if player.is_aiming(PLAYER.PLAYER_ID()) then
        if not GRAPHICS.ANIMPOSTFX_IS_RUNNING(effect) then
            GRAPHICS.ANIMPOSTFX_PLAY(effect, 0, true)
            MISC.SET_TIME_SCALE(0.4)
        end
    elseif GRAPHICS.ANIMPOSTFX_IS_RUNNING(effect) then
        GRAPHICS.ANIMPOSTFX_STOP(effect)
        MISC.SET_TIME_SCALE(1.0)
    end
end)

Weapon:add_looped_option("Kill karma", "BS_Weapon_KillKarma", 0.0, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    if not player.is_alive(PLAYER.PLAYER_ID()) then
        local entity = PED.GET_PED_SOURCE_OF_DEATH(ped)
        local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
        FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 34, 300.0, true, false, 1.0, false)
    end
end):setHint("Kills your killer.")

Weapon:add_bool_option("Debug gun [E]", "BS_Weapon_DebugGun", function (state)
    local taskName = "BS_Weapon_DebugGun"
    if state then
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if key == gui.keys.E and isDown then
                local pEntity = memory.alloc(8)
                if player.is_aiming(PLAYER.PLAYER_ID()) and PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), pEntity) then
                    local entity = memory.read_int64(pEntity)
                    local etype = "Unknown"
                    local ehealth = ENTITY.GET_ENTITY_HEALTH(entity)
                    local emaxhealth = ENTITY.GET_ENTITY_MAX_HEALTH(entity)
                    local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
                    local hash = ENTITY.GET_ENTITY_MODEL(entity)
                    if ENTITY.GET_ENTITY_TYPE(entity) == 1 then etype = "Ped"
                    elseif ENTITY.GET_ENTITY_TYPE(entity) == 2 then etype = "Vehicle"
                    elseif ENTITY.GET_ENTITY_TYPE(entity) == 3 then etype = "Object"
                    end
                    if entity ~= 0 then
                        log.default("Weapon", string.format("[Debug gun]\n\tEntity hash: %s\n\tID: %s\n\tType: %s\n\tHealth: %s\t Max heath: %s\n\tCoords: \n\tX: %s\tY: %s\tZ: %s\n", hash, entity, etype, ehealth, emaxhealth, coords.x, coords.y, coords.z))
                    end
                    notify.success("Weapon", "Copied entity info in console.", GET_NOTIFY_ICONS().weapons)
                end
                memory.free(pEntity)
            end
        end)
    elseif task.exists(taskName) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed)
    end
end):setHint("Prints entity info in console. Aim at it and press E.")


Weapon:add_choose_option("When aiming", "BS_Weapon_OnAiming", true, {"None", "Set night vision", "Set thermal vision"}, function (pos, option)
    local taskName = "BS_Weapon_OnAiming"
    local state = false
    if pos > 1 then
        task.createTask(taskName, 0.0, nil, function ()
            local function action(value)
                GRAPHICS.SET_NIGHTVISION(value)
            end
            if option:getValue() == 3 then
                action = function(value)
                    GRAPHICS.SET_SEETHROUGH(value)
                end
            end
            if player.is_aiming(PLAYER.PLAYER_ID()) then
                if not state then
                    action(true)
                    state = true
                end
            elseif state then
                action(false)
                state = false
            end
        end)
    elseif task.exists(taskName) then
        task.removeTask(taskName)
    end
end)
