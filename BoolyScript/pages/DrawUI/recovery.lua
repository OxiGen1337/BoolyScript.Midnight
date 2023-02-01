Recovery = Submenu.add_static_submenu("Recovery", "BS_Recovery")
Main:add_sub_option("Recovery", "BS_Recovery", Recovery)

Recovery:add_click_option("Summon the Gooch", "BS_Recovery_Gooch", function ()
    scripts.globals.callGooch()
end)

Recovery:add_separator("Nightclub", "BS_Recovery_Nightclub")

Recovery:add_click_option("How to use", "BS_Recovery_Nightclub_HowToUse", function()
    notify.important("Nightclub recovery", "Buy a nightclub\nSetup the nightclub\nOnce completely setup\nGo inside\nUse Tp to safe\nOpen safe\nTurn on nightclub money loop")
end)

-- Recovery:add_click_option("TP to safe", "BS_Recovery_Nightclub_TpToSafe", function()
--     local coords = Vector3(-1615.6827392578, -3015.6813964844, -75.205070495605)
--     if not coords then return end
--     features.teleport(coords)
-- end)

Recovery:add_bool_option("Nightclub money loop", "BS_Recovery_Nightclub_Enable", function(state)
    if state then 
        notify.warning("Nightclub recovery", "Use at own risk.")
        script_global:new(262145):at(23084):set_int64(133377)
        task.createTask("BS_Recovery_Nightclub_Enable", 5.0, nil, function ()
            script_global:new(262145):at(24045):set_int64(300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
            script_global:new(262145):at(24041):set_int64(300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
            for _, char in ipairs({"MP0_", "MP1_"}) do
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_POPULARITY"), 10000, true)
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_PAY_TIME_LEFT"), -1, true)
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_POPULARITY"), 100000, true)
            end
        end)
    elseif task.exists("BS_Recovery_Nightclub_Enable") then
        task.removeTask("BS_Recovery_Nightclub_Enable")
    end
end)