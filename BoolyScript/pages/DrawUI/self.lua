Self = Submenu.add_static_submenu("Self", "BS_Self_Submenu")
Main:add_sub_option("Self", "BS_Self_SubOption", Self)

local godmode = Submenu.add_static_submenu("Invincibility", "BS_Self_Godmode_Submenu") do
    godmode:add_bool_option("Godmode", "BS_Self_Godmode_Enable", function (state)
        ENTITY.SET_ENTITY_INVINCIBLE(PLAYER.PLAYER_PED_ID(), state)
    end)
    godmode:add_separator("Detailed", "BS_Self_Godmode_Detailed")
    local proofs = {
        ["Bullet"] = false,
        ["Fire"] = false,
        ["Explosion"] = false,
        ["Collision"] = false,
        ["Melee"] = false,
        ["Steam"] = false,
    }
    godmode:add_bool_option("Enable", "BS_Self_Godmode_Detailed_Enable", function (state)
        if state then 
            task.createTask("BS_Self_Godmode_Detailed", 0.0, nil, function ()
                ENTITY.SET_ENTITY_PROOFS(PLAYER.PLAYER_PED_ID(), proofs.Bullet, proofs.Fire, proofs.Explosion, proofs.Collision, proofs.Melee, proofs.Steam, false, false)
                log.dbg(proofs.Bullet)
            end)
        elseif task.exists("BS_Self_Godmode_Detailed") then
            task.removeTask("BS_Self_Godmode_Detailed")
        end
    end)
    for name, _ in pairs(proofs) do
        godmode:add_bool_option(name, "BS_Self_Godmode_Detailed_" .. name, function (state)
            proofs[name] = state
        end)
    end
    Self:add_sub_option("Invincibility", "BS_Self_Godmode_SubOption", godmode)
end

Self:add_separator("Movement", "BS_Self_Movement")

Self:add_looped_option("Clumsiness", "BS_Self_Movement_Clumsiness", 0.0, function ()
    PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), not PED.IS_PED_RUNNING_RAGDOLL_TASK(PLAYER.PLAYER_PED_ID()))
end)

Self:add_looped_option("No ragdoll", "BS_Self_Movement_NoRagdoll", 0.0, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    PED.SET_PED_CAN_RAGDOLL(ped, false)
    PED.SET_PED_CAN_RAGDOLL_FROM_PLAYER_IMPACT(ped, false)
    PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, false)
end, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    PED.SET_PED_CAN_RAGDOLL(ped, true)
    PED.SET_PED_CAN_RAGDOLL_FROM_PLAYER_IMPACT(ped, true)
    PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, true)
end)

Self:add_choose_option("Running speed", "BS_Self_Movement_RunSpeed", true, {"Default", "Medium", "Fast"}, function (_, option)
    task.createTask("BS_Self_Movement_RunSpeed", 0.0, nil, function ()
        local value = 1.0
        if option:getValue() == 2 then
            value = 1.25
        elseif option:getValue() == 3 then
            value = 1.49
        end
        PLAYER.SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), value)
    end)
end):setValue(1.0, true)

Self:add_choose_option("Swimming speed", "BS_Self_Movement_SwimSpeed",true, {"Default", "Medium", "Fast"}, function (_, option)
    task.createTask("BS_Self_Movement_SwimSpeed", 0.0, nil, function ()
        local value = 1.0
        if option:getValue() == 2 then
            value = 1.25
        elseif option:getValue() == 3 then
            value = 1.49
        end
        PLAYER.SET_SWIM_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), value)
    end)
end):setValue(1.0, true)

Self:add_looped_option("Swimming mode", "BS_Self_Movement_SwimmingMode", 0.0, function (state)
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 65, state)
end)

Self:add_looped_option("Shrink", "BS_Self_Movement_ShrinkMode", 0.0, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, true)
end, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, false)
end)

Self:add_looped_option("Always have a parachute", "BS_Self_Movement_AlwHaveParachute", 0.0, function (state)
    local ped = PLAYER.PLAYER_PED_ID()
    local hash = string.joaat("GADGET_PARACHUTE")
    if not WEAPON.HAS_PED_GOT_WEAPON(ped, hash, false) then
        WEAPON.GIVE_WEAPON_TO_PED(ped, hash, 5, false, false)
        notify.success("Self", "You've got a new parachute. Stay safe!")
    end
end)

Self:add_looped_option("Infinite stamina", "BS_Self_Movement_InfiniteStamina", 0.0, function ()
    PLAYER.RESET_PLAYER_STAMINA(PLAYER.PLAYER_ID())
end)

Self:add_separator("Gameplay", "BS_Self_Gameplay")

Self:add_looped_option("Total ignorе", "BS_Self_TotalIgnore", function ()
    local player = PLAYER.PLAYER_ID()
    PLAYER.SET_POLICE_IGNORE_PLAYER(player, true)
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(player, true)
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(player, false)
    PLAYER.SET_IGNORE_LOW_PRIORITY_SHOCKING_EVENTS(player, true)
end, function ()
    local player = PLAYER.PLAYER_ID()
    PLAYER.SET_POLICE_IGNORE_PLAYER(player, false)
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(player, false)
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(player, true)
    PLAYER.SET_IGNORE_LOW_PRIORITY_SHOCKING_EVENTS(player, false)
end):setHint("Most of peds nearby will ignore you.")

Self:add_click_option("Sky dive", "BS_Self_SkyDive", function ()
    local ped = PLAYER.PLAYER_PED_ID()
    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 0.0, 150.0)
    utils.teleport(coords)
    TASK.TASK_SKY_DIVE(ped, true)
end)

--END