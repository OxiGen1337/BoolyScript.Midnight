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
    task.createTask("artStrikeAtWp", 0.5, 20, function (cnt)        
        local coords = features.getWaypointCoords()
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

cleanupRadius = World:add_num_option("Cleanup raduis", "BS_World_CleanupRadius", 0, 600, 100):setValue(300)