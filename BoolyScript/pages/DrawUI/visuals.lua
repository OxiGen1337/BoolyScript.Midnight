Visual = Submenu.add_static_submenu("Visual", "BS_Visual")
Main:add_sub_option("Visual", "BS_Visual", Visual)

Visual:add_num_option("Fake wanted lvl", "BS_Visual_FakeWanted", 0, 6, 1, function(num)
	MISC.SET_FAKE_WANTED_LEVEL(math.ceil(num))
end):setHint("Don't worry, cops won't appear XD")

Visual:add_bool_option("Hide radar", "BS_Visual_HideRadar", function(state)
	HUD.DISPLAY_RADAR(not state)
end)

Visual:add_bool_option("Disable fake vehicles", "BS_Visual_DisableFakeVehicles", function(state)
    VEHICLE.SET_DISTANT_CARS_ENABLED(not state)
end):setHint("Disables vehicle shadows shown in large distance.")

Visual:add_looped_option("Allow pause in freemode", "BS_Visual_AllowFreemodePause", 0.0, function ()
    if HUD.IS_PAUSE_MENU_ACTIVE() then
        MISC.SET_TIME_SCALE(0.0)
    else
        MISC.SET_TIME_SCALE(1.0)
    end
end):setHint("Allows you to set your game on pause.")

Visual:add_looped_option("Allow pause when dead", "BS_Visual_AllowDeadPause", 0.0, function ()
    HUD._ALLOW_PAUSE_MENU_WHEN_DEAD_THIS_FRAME()
end)

Visual:add_looped_option("Allow waypoints in interiors", "BS_Visual_AllowWPInInteriors", 0.0, function ()
    HUD.SET_MINIMAP_BLOCK_WAYPOINT(false)
end)

Visual:add_looped_option("Hide BST screen effect", "BS_Visual_HideBSTScreenEffect", 0.0, function ()
    GRAPHICS.ANIMPOSTFX_STOP("MP_Bull_tost")
end):setHint("If you use BST you won't see its screen effect.")

Visual:add_looped_option("Disable speeches", "BS_Visual_DisableSpeeches", 0.0, function ()
    if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
        AUDIO.SKIP_TO_NEXT_SCRIPTED_CONVERSATION_LINE()
    end
end)

Visual:add_bool_option("Night vision", "BS_Visual_NightVision", function(state)
    GRAPHICS.SET_NIGHTVISION(state)
end)

Visual:add_bool_option("Thermal vision", "BS_Visual_ThermalVision", function(state)
    GRAPHICS.SET_SEETHROUGH(state)
end)

Visual:add_click_option("Skip cutscene", "BS_Visual_SkipCutscene", function ()
    scripts.globals.skipCutscene()
end)