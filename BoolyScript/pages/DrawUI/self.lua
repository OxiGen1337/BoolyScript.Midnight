Self = Submenu.add_static_submenu("Self", "BS_Self_Submenu")
Main:add_sub_option("Self", "BS_Self_SubOption", Self)

Self:add_separator("Movement", "BS_Self_Movement")

Self:add_looped_option("Clumsiness", "BS_Self_Movement_Clumsiness", 0.0, function ()
    PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), not PED.IS_PED_RUNNING_RAGDOLL_TASK(PLAYER.PLAYER_PED_ID()))
end)

Self:add_float_option("Running speed", "BS_Self_Movement_RunSpeed", 1.0, 1.49, 0.06, function (_, option)
    task.createTask("BS_Self_Movement_RunSpeed", 0.0, nil, function ()
        local mult = option:getValue() + .0
        PLAYER.SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
    end)
end):setValue(1.0, true)

Self:add_float_option("Swimming speed", "BS_Self_Movement_SwimSpeed", 1.0, 1.49, 0.06, function (_, option)
    task.createTask("BS_Self_Movement_SwimSpeed", 0.0, nil, function ()
        local mult = option:getValue()
        PLAYER.SET_SWIM_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
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
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 362, true)
end, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 362, false)
end)

--END