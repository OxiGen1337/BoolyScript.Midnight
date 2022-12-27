local scripts = require("BoolyScript/rage/scripts")
require("BoolyScript/util/notify_system")
local gui = require("BoolyScript/globals/gui")
require("BoolyScript/system/events_listener")
local features = require("BoolyScript/rage/features")

Self = Submenu.add_static_submenu("Self", "BS_Self_Submenu")
Main:add_sub_option("Self", "BS_Self_SubOption", Self)

Self:add_separator("Movement", "BS_Self_Movement")

Self:add_looped_option("Clumsiness", "BS_Self_Movement_Clumsiness", 0.0, function ()
    PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), not PED.IS_PED_RUNNING_RAGDOLL_TASK(PLAYER.PLAYER_PED_ID()))
end)

local runSpeed = Self:add_float_option("Running speed", "BS_Self_Movement_RunSpeed", 1.0, 1.49, 0.06)
local swimSpeed = Self:add_float_option("Swimming speed", "BS_Self_Movement_SwimSpeed", 1.0, 1.49, 0.06)

task.createTask("BS_Self_Movement_RunSpeed", 0.0, nil, function ()
    local mult = runSpeed:getValue() + .0
    PLAYER.SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
end)

task.createTask("BS_Self_Movement_SwimSpeed", 0.0, nil, function ()
    local mult = swimSpeed:getValue()
    PLAYER.SET_SWIM_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
end)

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

Self:add_separator("Weapon", "BS_Self_Weapon")

Self:add_looped_option("Dead eye effect", "BS_Self_Weapon_DeadEye", 0.0, function ()
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

Self:add_looped_option("Kill karma", "BS_Self_Weapon_KillKarma", 0.0, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    if not player.is_alive(PLAYER.PLAYER_ID()) then
        local entity = PED.GET_PED_SOURCE_OF_DEATH(ped)
        local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
        FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 34, 300.0, true, false, 1.0, false)
    end
end):setHint("Kills your killer.")

Self:add_bool_option("Debug gun [E]", "BS_Self_Weapon_DebugGun", function (state)
    local taskName = "BS_Self_Weapon_DebugGun"
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

local aimingState = nil

Self:add_choose_option("When aiming", "BS_Self_Weapon_OnAiming", true, {"None", "Set night vision", "Set thermal vision"}, function (pos)
    if pos > 1 then
        aimingState = memory.alloc(4)
    elseif aimingState then
        memory.free(aimingState)
    end
    local taskName = "BS_Self_Weapon_OnAiming"

    local function f()
        local state = memory.read_int64(aimingState) == 1
        local function action(value)
            GRAPHICS.SET_NIGHTVISION(value)
        end
        if pos == 3 then
            action = function(value)
                GRAPHICS.SET_SEETHROUGH(value)
            end
        end
        if player.is_aiming(PLAYER.PLAYER_ID()) then
            if not state then
                action(true)
                memory.write_int64(aimingState, 1)
            end
        elseif state then
            action(false)
            memory.write_int64(aimingState, 0)
        end
    end

    if task.exists(taskName) then
        task.setCallback(taskName, f)
    else
        task.createTask(taskName, 0.0, nil, f)
    end
    
end):setHint("Works only in SP.")

Self:add_separator("Visual", "BS_Self_Visual")

Self:add_num_option("Fake wanted lvl", "BS_Self_Visual_FakeWanted", 0, 6, 1, function(num)
	MISC.SET_FAKE_WANTED_LEVEL(num)
end):setHint("Don't worry, cops won't appear XD")

Self:add_bool_option("Hide radar", "BS_Self_Visual_HideRadar", function(state)
	HUD.DISPLAY_RADAR(not state)
end)

Self:add_bool_option("Disable fake vehicles", "BS_Self_Visual_DisableFakeVehicles", function(state)
    VEHICLE.SET_DISTANT_CARS_ENABLED(not state)
end):setHint("Disables vehicle shadows shown in large distance.")

Self:add_looped_option("Allow pause in freemode", "BS_Self_Visual_AllowFreemodePause", 0.0, function ()
    if HUD.IS_PAUSE_MENU_ACTIVE() then
        MISC.SET_TIME_SCALE(0.0)
    else
        MISC.SET_TIME_SCALE(1.0)
    end
end):setHint("Allows you to set your game on pause.")

Self:add_looped_option("Allow pause when dead", "BS_Self_Visual_AllowDeadPause", 0.0, function ()
    HUD._ALLOW_PAUSE_MENU_WHEN_DEAD_THIS_FRAME()
end)

Self:add_looped_option("Allow waypoints in interiors", "BS_Self_Visual_AllowWPInInteriors", 0.0, function ()
    HUD.SET_MINIMAP_BLOCK_WAYPOINT(false)
end)

Self:add_looped_option("Hide BST screen effect", "BS_Self_Visual_HideBSTScreenEffect", 0.0, function ()
    GRAPHICS.ANIMPOSTFX_STOP("MP_Bull_tost")
end):setHint("If you use BST you won't see its screen effect.")

Self:add_looped_option("Disable speeches", "BS_Self_Visual_DisableSpeeches", 0.0, function ()
    if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
        AUDIO.SKIP_TO_NEXT_SCRIPTED_CONVERSATION_LINE()
    end
end)

Self:add_bool_option("Night vision", "BS_Self_Visual_NightVision", function(state)
    GRAPHICS.SET_NIGHTVISION(state)
end)

Self:add_bool_option("Thermal vision", "BS_Self_Visual_ThermalVision", function(state)
    GRAPHICS.SET_SEETHROUGH(state)
end)

Self:add_bool_option("Skip cutscene", "BS_Self_Visual_SkipCutscene", function ()
    scripts.globals.skipCutscene()
end)

Self:add_separator("Area cleanup", "BS_Self_AreaCleanup")

Self:add_looped_option("Peds cleanup", "BS_Self_World_PedsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_PEDS(coords.x, coords.y, coords.z, radius, 0)
end)

Self:add_looped_option("Vehicles cleanup", "BS_Self_World_VehiclesCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_VEHICLES(coords.x, coords.y, coords.z, radius, false, false, false, false, false, 0)
end)

Self:add_looped_option("Cops cleanup", "BS_Self_World_CopsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_COPS(coords.x, coords.y, coords.z, radius, 0)
end)

Self:add_looped_option("Objects cleanup", "BS_Self_World_ObjectsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_OBJECTS(coords.x, coords.y, coords.z, radius, 0)
end)

Self:add_looped_option("Projectiles cleanup", "BS_Self_World_ProjCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, radius, 0)
end)

Self:add_num_option("Cleanup raduis", "BS_Self_World_CleanupRadius", 0, 600, 100):setValue(300)

Self:add_separator("World", "BS_Self_World")

Self:add_bool_option("Blackout", "BS_Self_World_Blackout", function(_, state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(false)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
end)

Self:add_bool_option("Total blackout", "BS_Self_World_TotalBlackout", function(_, state)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(state)
end)

Self:add_click_option("Artillery strike at waypoint", "BS_Self_World_ArtStrikeAtWP", function()
    task.createTask("artStrikeAtWp", 0.5, 20, function (cnt)        
        local coords = features.getWaypointCoords()
        local a = math.random(-10, 10)
        local b = math.random(-10, 10)
        FIRE.ADD_EXPLOSION(coords.x+a, coords.y-b, coords.z, 34, 300.0, true, false, 1.0, false)
    end)
end)

Self:add_bool_option("Riot mode", "BS_Self_World_RiotMode", function(_, state)
	MISC.SET_RIOT_MODE_ENABLED(state)
end):setHint("Makes peds around crazy so they shoot everyone.")

Self:add_choose_option("Gravity", "BS_Self_World_Gravity", true, {"Normal", "Lowered", "Moon", "No gravity"}, function (pos)
    MISC.SET_GRAVITY_LEVEL(pos-2)
end)

Self:add_separator("Misc", "BS_Self_Misc")

Self:add_click_option("Unlock all achievements", "BS_Self_Misc_UnlockAllAchievs", function()
    for ID = 1, 78 do
        PLAYER.GIVE_ACHIEVEMENT_TO_PLAYER(ID)
    end
end)

Self:add_looped_option("Remove transaction error", "BS_Self_Misc_RemoveTransactionError", 0.0, function ()
    scripts.globals.removeTransactionError()
end)

--END