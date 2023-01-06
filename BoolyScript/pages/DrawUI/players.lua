local players = {}

local activeActions = {}
local function addActiveAction(pid, option, value)
    if not option then return nil end
    if not activeActions[pid + 1] then activeActions[pid + 1] = {} end
    activeActions[pid + 1][option] = value
    return true
end

local submenus = {}

local selectedPlayer = nil

PlayerInteractions = Submenu.add_static_submenu("Player", "BS_PlayerList_Player_Submenu") do 
    PlayerInteractions:add_state_bar("Name:", "BS_PlayerList_Interactions_NameBar", function ()
        if not selectedPlayer or not player.is_connected(selectedPlayer) then return "None" end
        return player.get_name(selectedPlayer)
    end)
    table.insert(submenus, PlayerInteractions)
end

-- PlayerInteractions:add_click_option("Test", "", function ()
--     script.send(selectedPlayer, 243072129, selectedPlayer, 263, -1)
-- end)

PlayerTeleport = Submenu.add_static_submenu("Teleport", "BS_PlayerList_Player_Teleport_Submenu") do
    PlayerTeleport:add_click_option("Teleport to player", "BS_PlayerList_Player_Teleport_ToPlayer", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
        utils.teleport(coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Teleport in vehicle", "BS_PlayerList_Player_Teleport_InVehicle", function ()
        local pid = selectedPlayer
        local vehicle = player.get_vehicle_handle(pid)
        if vehicle == 0 then return end
        local coords = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        for seat = -1, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(vehicle)) - 1 do
            if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, seat, false) then
                utils.teleport(coords)
                PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, seat)
                return
            end
        end
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Teleport vehicle to me", "BS_PlayerList_Player_Teleport_VehToMe", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0.0, 5.0, 0.0)
        utils.teleport(vehicle, coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Parachute to", "BS_PlayerList_Player_Teleport_Parachute", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0.0, 0.0, 150.0)
        utils.teleport(coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Enter player's interior", "BS_PlayerList_Player_Teleport_Interior", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not player.is_in_interior(pid) then return end
        local interior = player.get_interior_handle(pid)
        player.teleport_to_interior(player.index(), interior)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Teleport", "BS_PlayerList_Teleport_SubOption", PlayerTeleport)
    table.insert(submenus, PlayerTeleport)
end

PlayerVehicle = Submenu.add_static_submenu("Vehicle", "BS_PlayerList_Player_Vehicle_Submenu") do
    PlayerVehicle:add_click_option("Kick from vehicle", "BS_PlayerList_Player_Vehicle_VehicleKick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        player.vehicle_kick(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Disown vehicle", "BS_PlayerList_Player_Vehicle_Disown", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        player.vehicle_disown(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Send EMP", "BS_PlayerList_Player_Vehicle_EMP", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        player.vehicle_emp(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Rotate 180", "BS_PlayerList_Player_Vehicle_Rotate180", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 5)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_ROTATION(hdl, rotation.x + 180, rotation.y, rotation.z, 5, true)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Freeze", "BS_PlayerList_Player_Vehicle_Freeze", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.FREEZE_ENTITY_POSITION(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_choose_option("Boost", "BS_PlayerList_Player_Vehicle_Boost", false, {"Forward", "Back", "Right", "Left", "Up", "Down"}, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, value)
        local vehicle = player.get_vehicle_handle(pid)
        local function f(func)
            return func()
        end
        local force = 10.0
        local vector = {
            x = f(function ()
                if value == 1 then return force end
                if value == 2 then return -force end
            end),
            y = f(function ()
                if value == 3 then return force end
                if value == 4 then return -force end
            end),
            z = f(function ()
                if value == 5 then return force end
                if value == 6 then return -force end
            end)
        }
        entity.request_control(vehicle, function (hdl)
            ENTITY.APPLY_FORCE_TO_ENTITY(hdl, vector.x, vector.y, vector.z, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_choose_option("Upgrade", "BS_PlayerList_Player_Vehicle_Upgrade", false, {"Default", "Random", "Power", "Max"}, function (pos, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, pos)
        local vehicle = player.get_vehicle_handle(pid)
        features.setVehiclePreset(vehicle, pos)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Burst tyres", "BS_PlayerList_Player_Vehicle_BurstTyres", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            for i = 0, 7 do
                VEHICLE.SET_VEHICLE_TYRE_BURST(hdl, i, true, 1000.0)
            end
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Invincible", "BS_PlayerList_Player_Vehicle_Godmode", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_INVINCIBLE(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Revive engine", "BS_PlayerList_Player_Vehicle_ReviveEngine", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(hdl, 1000)
			VEHICLE.SET_VEHICLE_BODY_HEALTH(hdl, 1000)
			VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(hdl, 1000)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Destroy engine", "BS_PlayerList_Player_Vehicle_DestroyEngine", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(hdl, -4000)
			VEHICLE.SET_VEHICLE_BODY_HEALTH(hdl, -4000)
			VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(hdl, -4000)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Smash windows", "BS_PlayerList_Player_Vehicle_SmashWindows", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            for i = 0, 8 do
                VEHICLE.SMASH_VEHICLE_WINDOW(hdl, i)
            end
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Repair & wash", "BS_PlayerList_Player_Vehicle_Repair", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_FIXED(hdl)
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(hdl, 0.0)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Repair shell", "BS_PlayerList_Player_Vehicle_RepairShell", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(hdl)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Enable alarm", "BS_PlayerList_Player_Vehicle_Alarm", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_ALARM(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Lock vehicle", "BS_PlayerList_Player_Vehicle_Lock", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            if state then
                VEHICLE.SET_VEHICLE_DOORS_LOCKED(hdl, 2)
            else
                VEHICLE.SET_VEHICLE_DOORS_LOCKED(hdl, 1)
            end
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Disable gravity", "BS_PlayerList_Player_Vehicle_NoGravity", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_GRAVITY(hdl, not state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_separator("Remote vehicle control", "BS_PlayerList_Player_Vehicle_RVC")
    local task_time = 1000
    PlayerVehicle:add_num_option("Task time", "BS_PlayerList_Player_Vehicle_RVC_TaskTime", 1, 600, 1, function (val)
        task_time = val * 1000
    end):setValue(1):setConfigIgnore()
    PlayerVehicle:add_click_option("Brake", "BS_PlayerList_Player_Vehicle_RVC_Brake", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 1, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Brake + Reverse", "BS_PlayerList_Player_Vehicle_RVC_BrakeReverse", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 3, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Brake + Strong Reverse", "BS_PlayerList_Player_Vehicle_RVC_BrakeStrongReverse", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 28, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Turn Left + Accelerate", "BS_PlayerList_Player_Vehicle_RVC_TurnLeft", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 7, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Turn Right + Accelerate", "BS_PlayerList_Player_Vehicle_RVC_TurnRight", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 8, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Accelerate", "BS_PlayerList_Player_Vehicle_RVC_Accelerate", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 23, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Strong Accelerate", "BS_PlayerList_Player_Vehicle_RVC_StrongAccelerate", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 32, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Spin Forever", "BS_PlayerList_Player_Vehicle_RVC_SpinForever", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 7, 2147483647)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Stop Forever", "BS_PlayerList_Player_Vehicle_RVC_StopForever", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), vehicle, 1, 2147483647)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Vehicle", "BS_PlayerList_Player_Vehicle_SubOption", PlayerVehicle)
    table.insert(submenus, PlayerVehicle)
end

PlayerRemovals = Submenu.add_static_submenu("Removals", "BS_PlayerList_Player_Removals_Submenu") do
    PlayerRemovals:add_click_option("Kick [Host/Vote]", "BS_PlayerList_Player_Removals_Kick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.kick(pid)
    end)    
    PlayerRemovals:add_click_option("Kick [Script Events]", "BS_PlayerList_Player_Removals_SEKick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.kick_brute(pid)
    end)    
    PlayerRemovals:add_click_option("Kick [IDM]", "BS_PlayerList_Player_Removals_IDMKick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.kick_idm(pid)
    end)
    PlayerInteractions:add_sub_option("Removals", "BS_PlayerList_Player_Removals_SubOption", PlayerRemovals)
    table.insert(submenus, PlayerRemovals)
end

PlayerBlocks = Submenu.add_static_submenu("Block", "BS_PlayerList_Player_Block_Submenu") do
    PlayerBlocks:add_bool_option("Block sync", "BS_PlayerList_Player_Block_Sync", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if state and not player.is_banned(pid) then 
            player.ban(pid, -1, "Manual block") 
        elseif not state and player.is_banned(pid) then 
            player.unban(pid) 
        end
        addActiveAction(pid, option, state)
    end):setConfigIgnore()
    PlayerBlocks:add_bool_option("Block all script events", "BS_PlayerList_Player_Block_SE", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local name = "BS_PlayerList_Player_Block_SE_" .. pid 
        if state then
            listener.register(name, GET_EVENTS_LIST().OnScriptEvent, function (ply)
                if pid == ply then return false end
            end)
            listener.register(name, GET_EVENTS_LIST().OnFeatureTick, function ()
                if not player.is_connected(pid) and listener.exists(name, GET_EVENTS_LIST().OnScriptEvent) then
                    listener.remove(name, GET_EVENTS_LIST().OnScriptEvent)
                    listener.remove(name, GET_EVENTS_LIST().OnFeatureTick)
                end
            end)
        else
            listener.remove(name, GET_EVENTS_LIST().OnScriptEvent)
            listener.remove(name, GET_EVENTS_LIST().OnFeatureTick)
        end
        addActiveAction(pid, option, state)
    end):setConfigIgnore()
    PlayerBlocks:add_bool_option("Block all network events", "BS_PlayerList_Player_Block_NE", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local name = "BS_PlayerList_Player_Block_NE_" .. pid 
        if state then
            listener.register(name, GET_EVENTS_LIST().OnNetworkEvent, function (ply)
                if pid == ply then return false end
            end)
            listener.register(name, GET_EVENTS_LIST().OnFeatureTick, function ()
                if not player.is_connected(pid) and listener.exists(name, GET_EVENTS_LIST().OnNetworkEvent) then
                    listener.remove(name, GET_EVENTS_LIST().OnNetworkEvent)
                    listener.remove(name, GET_EVENTS_LIST().OnFeatureTick)
                end
            end)
        else
            listener.remove(name, GET_EVENTS_LIST().OnNetworkEvent)
            listener.remove(name, GET_EVENTS_LIST().OnFeatureTick)
        end
        addActiveAction(pid, option, state)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Block", "BS_PlayerList_Player_Block_SubOption", PlayerBlocks)
    table.insert(submenus, PlayerBlocks)
end

PlayerNeutral = Submenu.add_static_submenu("Neutral", "BS_Players_Neutral_Submenu") do
    PlayerNeutral:add_click_option("Copy outfit", "BS_Players_Neutral_CopyOutfit", function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        for i = 0, 11 do
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_DRAWABLE_VARIATION(ped, i), PED.GET_PED_TEXTURE_VARIATION(ped, i), PED.GET_PED_PALETTE_VARIATION(ped, i))
        end
        for i = 0, 7 do
            if PED.GET_PED_PROP_INDEX(ped, i) >= 0 and PED.GET_PED_PROP_TEXTURE_INDEX(ped, i) >= 0 then
                PED.SET_PED_PROP_INDEX(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_PROP_INDEX(ped, i), PED.GET_PED_PROP_TEXTURE_INDEX(ped, i), true)
            end
        end
    end)
    PlayerNeutral:add_click_option("Clear wanted level", "BS_Players_Neutral_ClearWanted", function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        player.clear_wanted_level(pid)
    end)
    PlayerNeutral:add_click_option("Send cops blind eye", "BS_Players_Neutral_CBE", function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        player.cops_blind_eye(pid)
    end)
    PlayerNeutral:add_click_option("Send off the radar", "BS_Players_Neutral_OTR", function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        player.off_the_radar(pid)
    end)
    PlayerInteractions:add_sub_option("Neutral", "BS_Players_Neutral_SubOption", PlayerNeutral)
end

PlayerGriefing = Submenu.add_static_submenu("Griefing", "BS_PlayerList_Player_Griefing_Submenu") do
    PlayerGriefing:add_click_option("Teleport to island", "BS_PlayerList_Player_Griefing_TeleportToIsland", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.teleport_to_island(pid, false)
    end):setConfigIgnore()
    PlayerGriefing:add_click_option("Teleport to interior", "BS_PlayerList_Player_Griefing_TeleportToInt", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.teleport_to_interior(pid, 1)
    end):setConfigIgnore()
    PlayerGriefing:add_click_option("Force to mission", "BS_PlayerList_Player_Griefing_ForceMission", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.teleport_to_mission(pid)
    end):setConfigIgnore()
    PlayerGriefing:add_click_option("Force in cutscene", "BS_PlayerList_Player_Griefing_ForceCutscene", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.teleport_to_cutscene(pid)
    end):setConfigIgnore()
    PlayerGriefing:add_click_option("Set 10K bounty", "BS_PlayerList_Player_Griefing_SetBounty", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        player.set_bounty(pid, 10000, true)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Griefing", "BS_PlayerList_Griefing_SubOption", PlayerGriefing)
    table.insert(submenus, PlayerGriefing)
end


-- for pid = 0, 32 do
--     local option = setmetatable({}, Option)
--     option.ID = #players + 1
--     option.name = "PID: " .. pid
--     option.type = OPTIONS.SUB
--     option.hash = "PlayerList_" .. pid
--     option.value = pid
--     option.callback = function ()
--         selectedPlayer = pid
--         PlayerInteractions:setActive(true)
--         if activeActions[pid + 1] then
--             for option, value in pairs(activeActions[pid + 1]) do
--                 option:setValue(value, true)
--             end
--         else
--             for _, submenu in ipairs(submenus) do
--                 for _, option in ipairs(submenu.options) do
--                     option:reset(true)
--                 end
--             end
--         end
--     end
--     table.insert(players, option)
-- end

local function getPlayerFlags(pid)
    if not player.is_connected(pid) then return "" end
    local out = {}
    if player.is_local(pid) then table.insert(out, {"[ME]", 255, 255, 51}) end
    if player.is_god(pid) then table.insert(out, {"[G]", 0, 153, 255}) end
    if player.is_script_host(pid) then table.insert(out, {"[SH]", 204, 51, 204}) end
    if player.is_session_host(pid) then table.insert(out, {"[H]", 255, 102, 102}) end
    if player.is_in_interior(pid) then table.insert(out, {"[I]", 0, 204, 204}) end    
    if player.is_in_vehicle(pid) then table.insert(out, {"[V]", 204, 255, 0}) end
    if player.is_in_cutscene(pid) then table.insert(out, {"[CS]", 204, 204, 204}) end
    if player.is_modder(pid) then table.insert(out, {"[M]", 255, 0, 102}) end
    if player.is_friend(pid) then table.insert(out, {"[F]", 0, 255, 153}) end
    if player.is_rockstar_dev(pid) then table.insert(out, {"[R]", 252, 43, 85}) end
    if player.is_banned(pid) then table.insert(out, {"[B]", 193, 240, 74}) end
    if player.is_next_host(pid) then table.insert(out, {"[NS]", 107, 223, 227}) end
    return out
end

PlayerList = Submenu.add_dynamic_submenu("Players list", "BS_PlayerList_Submenu", function ()
    for pid = 0, 32 do
        if player.is_connected(pid) then
            PlayerList:add_sub_option(player.get_name(pid), "Player_" .. pid, PlayerInteractions, function ()
                selectedPlayer = pid
                if activeActions[pid + 1] then
                    for option, value in pairs(activeActions[pid + 1]) do
                        option:setValue(value, true)
                    end
                else
                    for _, submenu in ipairs(submenus) do
                        for _, option in ipairs(submenu.options) do
                            option:reset(true)
                        end
                    end
                end
            end):setTags(getPlayerFlags(pid))
        else
            activeActions[pid + 1] = nil
        end
    end
end)

Main:add_sub_option("Players", "BS_PlayerList_SubOption", PlayerList)

PlayerInteractions:add_click_option("Copy info", "BS_Players_Info_CopyInfo", function ()
    local pid = selectedPlayer
    if not player.is_connected(pid) then return end
    local out = string.format("Player info\nName: %s\nRID: %i\nIP: %s", player.get_name(pid), player.get_rid(pid), player.get_ip_string(pid))
    utils.set_clipboard(out)
    notify.success("Players", "Copied player info to clipboard.")
end)

-- END