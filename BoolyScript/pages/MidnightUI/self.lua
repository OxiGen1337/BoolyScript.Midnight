require("BoolyScript/util/menu")
local callbacks = require("BoolyScript/rage/callbacks")
local scripts = require("BoolyScript/rage/scripts")
require("BoolyScript/util/notify_system")
local gui = require("BoolyScript/globals/gui")
require("BoolyScript/system/events_listener")
local features = require("BoolyScript/rage/features")

local page = GET_PAGES()['BS_Main']
local self = menu.add_mono_block(page, "Self", "BS_Self", BLOCK_ALIGN_LEFT)

-- menu.add_static_text(self, "Animations", "BS_Self_Animations")

-- local animsTable = {
--     ["Sexual"] = {
--         ["Doggystyle 1"] = { "rcmpaparazzo_2", "shag_loop_poppy" },
--         ["Doggystyle 2"] = { "rcmpaparazzo_2", "shag_loop_a" },
--         ["Shaking Ass"] = { "switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper" },
--         ["Slow Humping"] = { "misscarsteal2pimpsex", "shagloop_pimp" }
--     },
--     ["Animals"] = {
--         ["Monkey"] = { "missfbi5ig_30monkeys", "monkey_b_freakout_loop" }, 
--         ["Chop Hump"] = { "missfra0_chop_find", "hump_loop_chop" },
--         ["Chop Swim"] = { "creatures@rottweiler@swim@", "swim" }
--     },
--     ["Actions"] = {
--         ["Air Guitar"] = { "anim@mp_player_intcelebrationfemale@air_guitar", "air_guitar"},
--         ["Blow Kiss"] = { "anim@mp_player_intcelebrationfemale@blow_kiss", "blow_kiss"},
--         ["Bro Hug"] = { "anim@mp_player_intcelebrationpaired@f_m_bro_hug", "bro_hug_right"},
--         ["Challenge"] = { "misscommon@response", "face_palm"},
--         ["Face Palm"] = { "anim@mp_player_intcelebrationmale@face_palm", ""},
--         ["Finger"] = { "anim@mp_player_intcelebrationmale@finger", "finger"},
--         ["Hands Up"] = { "mp_pol_bust_out", "guard_handsup_loop"},
--         ["Hump Air"] = { "anim@mp_player_intcelebrationfemale@air_shagging", "air_shagging"},
--         ["Jazz Hands"] = { "anim@mp_player_intcelebrationmale@jazz_hands", "jazz_hands"},
--         ["Nose Pick"] = { "anim@mp_player_intcelebrationmale@nose_pick", "nose_pick"},
--         ["Photographer"] = { "anim@mp_player_intcelebrationmale@photography", "photography"},
--         ["Salute"] = { "anim@mp_player_intcelebrationmale@salute", "salute"},
--         ["Shush"] = { "anim@mp_player_intcelebrationmale@shush", "shush"},
--         ["Slow Clap"] = { "anim@mp_player_intcelebrationmale@slow_clap", "slow_clap"},
--         ["Smoke"] = { "anim@mp_player_intcelebrationmale@smoke_flick", "smoke_flick"},
--         ["Surrender"] = { "anim@mp_player_intcelebrationmale@surrender", "surrender"},
--         ["Synth"] = { "anim@mp_player_intcelebrationfemale@air_synth", "air_synth"},
--         ["Thumbs Up"] = { "anim@mp_player_intcelebrationmale@thumbs_up", "thumbs_up"},
--         ["Wank"] = { "mp_player_intwank", "mp_player_int_wank" }
--     },
--     ["Dance"] = {
--         ["Casual"] = { "rcmnigel1bnmt_1b", "dance_loop_tyler"},
--         ["Clown"] = { "rcm_barry2", "clown_idle_6"},
--         ["Pole"] = { "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03"},
--         ["Private"] = { "mini@strip_club@private_dance@part2", "priv_dance_p2"},
--         ["Receive"] = { "mp_am_stripper", "lap_dance_player"},
--         ["Sexual"] = { "mini@strip_club@pole_dance@pole_a_2_stage", "pole_a_2_stage"},
--         ["Yacht"] = { "oddjobs@assassinate@multi@yachttarget@lapdance", "yacht_ld_f" }
--     },
--     ["Misc"] = {
--         ["Electrocute"] = { "ragdoll@human", "electrocute"},
--         ["Hover"] = { "swimming@base", "dive_idle"},
--         ["Jump"] = { "move_jump", "jump_launch_l_to_skydive"},
--         ["Meditate"] = { "rcmcollect_paperleadinout@", "meditiate_idle"},
--         ["Party"] = { "rcmfanatic1celebrate", "celebrate"},
--         ["Pissing"] = { "misscarsteal2peeing", "peeing_loop"},
--         ["Push Ups"] = { "rcmfanatic3", "ef_3_rcm_loop_maryann"},
--         ["Run"] = { "move_m@alien", "alien_run"},
--         ["Shitting"] = { "missfbi3ig_0", "shit_loop_trev"},
--         ["Showering"] = { "mp_safehouseshower@male@", "male_shower_idle_b"},
--         ["Swim"] = { "swimming@scuba", "dive_idle"},
--         ["Vomit"] = { "missfam5_blackout", "vomit"},
--         ["Wave Forward"] = { "friends@frj@ig_1", "wave_d"},
--         ["Wave Hands High"] = { "random@prisoner_lift", "arms_waving"},
--         ["Wave One Arm"] = { "random@shop_gunstore", "_greeting" }
--     }
-- }

-- local animsClasses = {"Sexual", "Animals", "Actions", "Dance", "Misc"}
-- local selectedClassTable = {}
-- local currentAnimInfo = {
--     ["name"] = "NULL",
--     ["dict"] = "NULL",
--     ["anim"] = "NULL"
-- }

-- menu.add_combo(self, "Class", "BS_Self_Animations_Class", animsClasses, function (data, pos)
--     selectedClassTable = {}
--     for key, _ in pairs(animsTable[animsClasses[pos]]) do
--         table.insert(selectedClassTable, key)
--     end
--     GET_OPTIONS().combo['BS_Self_Animations_Anim']:set_table(selectedClassTable)
-- end)

-- menu.add_combo(self, "Animation", "BS_Self_Animations_Anim", {"None"}, function(data, pos)
--     local class = animsClasses[GET_OPTIONS().combo['BS_Self_Animations_Class']:get()+1]
--     local table = animsTable[class][selectedClassTable[pos]]
--     currentAnimInfo = {
--         ["name"] = class,
--         ["dict"] = table[1],
--         ["anim"] = table[2]
--     }
-- end)

-- menu.add_slider_int(self, "Duration", "BS_Self_Animations_Duration", -1, 99999):set(-1)

-- menu.add_button(self, "Play", "BS_Self_Animations_Play", function()
--     callbacks.requestAnimDict(currentAnimInfo.dict, function()
--         TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
--         TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), currentAnimInfo.dict, currentAnimInfo.anim, 8.0, 8.0, GET_OPTIONS().sliderInt['animsDuration']:get(), 0, 0.0, false, false, false) 
--     end)
-- end)

-- menu.add_button(self, "Stop", "BS_Self_Animations_Stop" , function()
--     TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
-- end)

menu.add_static_text(self, "Movement", "BS_Self_Movement")

menu.add_looped_option(self, "Clumsiness", "BS_Self_Movement_Clumsiness", 0.0, function ()
    PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), not PED.IS_PED_RUNNING_RAGDOLL_TASK(PLAYER.PLAYER_PED_ID()))
end)

local runSpeed = menu.add_slider_float(self, "Running speed", "BS_Self_Movement_RunSpeed", 1.0, 1.49)
local swimSpeed = menu.add_slider_float(self, "Swimming speed", "BS_Self_Movement_SwimSpeed", 1.0, 1.49)

task.createTask("BS_Self_Movement_RunSpeed", 0.0, nil, function ()
    local mult = runSpeed:get()
    PLAYER.SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
end)

task.createTask("BS_Self_Movement_SwimSpeed", 0.0, nil, function ()
    local mult = swimSpeed:get()
    PLAYER.SET_SWIM_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), mult)
end)

menu.add_looped_option(self, "Swimming mode", "BS_Self_Movement_SwimmingMode", 0.0, function (_, state)
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 65, state)
end)

menu.add_looped_option(self, "Shrink", "BS_Self_Movement_ShrinkMode", 0.0, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, true)
end, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, false)
end)

menu.add_looped_option(self, "Always have a parachute", "BS_Self_Movement_AlwHaveParachute", 0.0, function (data, state)
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 362, true)
end, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 362, false)
end)

menu.add_static_text(self, "Weapon", "BS_Self_Weapon")

menu.add_looped_option(self, "Dead eye effect", "BS_Self_Weapon_DeadEye", 0.0, function ()
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

menu.add_looped_option(self, "Kill karma", "BS_Self_Weapon_KillKarma", 0.0, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    if not player.is_alive(PLAYER.PLAYER_ID()) then
        local entity = PED.GET_PED_SOURCE_OF_DEATH(ped)
        local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
        FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 34, 300.0, true, false, 1.0, false)
    end
end)

menu.add_checkbox(self, "Debug gun [E]", "BS_Self_Weapon_DebugGun", function (data, state)
    local taskName = "BS_Self_Weapon_DebugGun"
    if state then
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if key == gui.keys.E and isDown then
                local pEntity = memory.alloc(8)
                if player.is_aiming(PLAYER.PLAYER_ID()) and PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), pEntity) then
                    local entity = memory.read_int64(pEntity)
                    local etype
                    local ehealth = ENTITY.GET_ENTITY_HEALTH(entity)
                    local emaxhealth = ENTITY.GET_ENTITY_MAX_HEALTH(entity)
                    local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
                    local hash = ENTITY.GET_ENTITY_MODEL(entity)
                    if ENTITY.GET_ENTITY_TYPE(entity) == 1 then etype = "Ped"
                    elseif ENTITY.GET_ENTITY_TYPE(entity) == 2 then etype = "Vehicle"
                    elseif ENTITY.GET_ENTITY_TYPE(entity) == 3 then etype = "Object"
                    else etype = "Unknown"
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
end)

local aimingState = nil

menu.add_combo(self, "When aiming", "BS_Self_Weapon_OnAiming", {"None", "Set night vision", "Set thermal vision"}, function (_, pos)
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
    
end)

menu.add_static_text(self, "Visual", "BS_Self_Visual")

menu.add_slider_int(self, "Fake wanted lvl", "BS_Self_Visual_FakeWanted", 0, 6, function(_, num)
	MISC.SET_FAKE_WANTED_LEVEL(num)
end)

menu.add_checkbox(self, "Hide radar", "BS_Self_Visual_HideRadar", function(_, state)
	HUD.DISPLAY_RADAR(not state)
end)

menu.add_checkbox(self, "Disable fake vehicles", "BS_Self_Visual_DisableFakeVehicles", function(_, state)
    VEHICLE.SET_DISTANT_CARS_ENABLED(not state)
end)

menu.add_looped_option(self, "Allow pause in freemode", "BS_Self_Visual_AllowFreemodePause", 0.0, function ()
    if HUD.IS_PAUSE_MENU_ACTIVE() then
        MISC.SET_TIME_SCALE(0.0)
    else
        MISC.SET_TIME_SCALE(1.0)
    end
end)

menu.add_looped_option(self, "Allow pause when dead", "BS_Self_Visual_AllowDeadPause", 0.0, function ()
    HUD._ALLOW_PAUSE_MENU_WHEN_DEAD_THIS_FRAME()
end)

menu.add_looped_option(self, "Allow waypoints in interiors", "BS_Self_Visual_AllowWPInInteriors", 0.0, function ()
    HUD.SET_MINIMAP_BLOCK_WAYPOINT(false)
end)

menu.add_looped_option(self, "Hide BST screen effect", "BS_Self_Visual_HideBSTScreenEffect", 0.0, function ()
    GRAPHICS.ANIMPOSTFX_STOP("MP_Bull_tost")
end)

menu.add_looped_option(self, "Disable speeches", "BS_Self_Visual_DisableSpeeches", 0.0, function ()
    if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
        AUDIO.SKIP_TO_NEXT_SCRIPTED_CONVERSATION_LINE()
    end
end)

menu.add_checkbox(self, "Night vision", "BS_Self_Visual_NightVision", function(_, state)
    GRAPHICS.SET_NIGHTVISION(state)
end)

menu.add_checkbox(self, "Thermal vision", "BS_Self_Visual_ThermalVision", function(_, state)
    GRAPHICS.SET_SEETHROUGH(state)
end)

menu.add_button(self, "Skip cutscene", "BS_Self_Visual_SkipCutscene", function ()
    scripts.globals.skipCutscene()
end)

menu.add_static_text(self, "World", "BS_Self_World")


menu.add_looped_option(self, "Peds cleanup", "BS_Self_World_PedsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_PEDS(coords.x, coords.y, coords.z, radius, 0)
end)

menu.add_looped_option(self, "Vehicles cleanup", "BS_Self_World_VehiclesCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_VEHICLES(coords.x, coords.y, coords.z, radius, false, false, false, false, false, 0)
end)

menu.add_looped_option(self, "Cops cleanup", "BS_Self_World_CopsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_COPS(coords.x, coords.y, coords.z, radius, 0)
end)

menu.add_looped_option(self, "Objects cleanup", "BS_Self_World_ObjectsCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_OBJECTS(coords.x, coords.y, coords.z, radius, 0)
end)

menu.add_looped_option(self, "Projectiles cleanup", "BS_Self_World_ProjCleanup", 0.0, function ()
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local radius = GET_OPTIONS().sliderInt['BS_Self_World_CleanupRadius']:get() + .0
    MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, radius, 0)
end)

menu.add_slider_int(self, "Cleanup raduis", "BS_Self_World_CleanupRadius", 0, 600):set(300)


menu.add_checkbox(self, "Blackout", "BS_Self_World_Blackout", function(_, state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(false)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
end)

menu.add_checkbox(self, "Total blackout", "BS_Self_World_TotalBlackout", function(_, state)
    GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(state)
    GRAPHICS._SET_ARTIFICIAL_LIGHTS_STATE_AFFECTS_VEHICLES(state)
end)

menu.add_button(self, "Artillery strike at waypoint", "BS_Self_World_ArtStrikeAtWP", function()
    task.createTask("artStrikeAtWp", 0.5, 20, function (cnt)        
        local coords = features.getWaypointCoords()
        local a = math.random(-10, 10)
        local b = math.random(-10, 10)
        FIRE.ADD_EXPLOSION(coords.x+a, coords.y-b, coords.z, 34, 300.0, true, false, 1.0, false)
    end)
end)

menu.add_checkbox(self, "Riot mode", "BS_Self_World_RiotMode", function(_, state)
	MISC.SET_RIOT_MODE_ENABLED(state)
end)

menu.add_combo(self, "Gravity", "BS_Self_World_Gravity", {"Normal", "Lowered", "Moon", "No gravity"}, function (_, pos)
    MISC.SET_GRAVITY_LEVEL(pos-1)
end)

menu.add_static_text(self, "Misc", "BS_Self_Misc")

menu.add_button(self, "Unlock all achievements", "BS_Self_Misc_UnlockAllAchievs", function()
    for ID = 1, 78 do
        PLAYER.GIVE_ACHIEVEMENT_TO_PLAYER(ID)
    end
end)

menu.add_looped_option(self, "Remove transaction error", "BS_Self_Misc_RemoveTransactionError", 0.0, function ()
    scripts.globals.removeTransactionError()
end)

--END