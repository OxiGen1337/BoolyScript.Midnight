local players = {}

local pussy_mode = false

local function pussy_func(pid, time, reason)
    if pussy_mode and not player.is_banned(pid) then
        player.ban(pid, time, reason)
        notify.success(reason, "Blocked syncs with " .. player.get_name(pid) .. " for " .. time .. "s")
    elseif pussy_mode and player.is_banned(pid) then
        notify.fatal(reason, "Failed to block syncs with " .. player.get_name(pid) .. " | Already blocked")
    end
end

local activeActions = {}
local function addActiveAction(pid, option, value)
    if not option then return nil end
    if not activeActions[pid + 1] then activeActions[pid + 1] = {} end
    activeActions[pid + 1][option] = value
    return true
end

local submenus = {}

local selectedPlayer = 0

function GetSelectedPlayer()
    return selectedPlayer
end

PlayerInteractions = Submenu.add_static_submenu("Player", "BS_PlayerList_Player") do 
    PlayerInteractions:add_state_bar("Name:", "BS_PlayerList_Interactions_NameBar", function ()
        if not selectedPlayer or not player.is_connected(selectedPlayer) then return "None" end
        return player.get_name(selectedPlayer)
    end)
    table.insert(submenus, PlayerInteractions)
end

PlayerSettings = Submenu.add_static_submenu("Settings", "BS_PlayerList_Player_Settings") do
    PlayerSettings:add_bool_option("Pussy mode", "BS_PlayerList_Player_Settings_PussyMode", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        pussy_mode = state
    end):setHint("Blocks syncs after sending kick/crash for 30s")
    PlayerInteractions:add_sub_option("Settings", "BS_PlayerList_Settings", PlayerSettings)
    table.insert(submenus, PlayerSettings)
end

PlayerInteractions:add_bool_option("Spectate", "BS_PlayerList_Player_Spectate", function (state, option)
    if state then
        if Stuff.spectatingPlayer then
            addActiveAction(Stuff.spectatingPlayer, option, false)
        end
        Stuff.spectatingPlayer = GetSelectedPlayer()
    else
        Stuff.spectatingPlayer = nil
    end
    NETWORK.NETWORK_SET_IN_SPECTATOR_MODE(state, player.get_entity_handle(GetSelectedPlayer()))
    addActiveAction(GetSelectedPlayer(), option, state)
end)

PlayerTeleport = Submenu.add_static_submenu("Teleport", "BS_PlayerList_Player_Teleport") do
    PlayerTeleport:add_click_option("Teleport to player", "BS_PlayerList_Player_Teleport_ToPlayer", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_ENTITY_COORDS(player.get_entity_handle(pid), false)
        features.teleport(coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Teleport in vehicle", "BS_PlayerList_Player_Teleport_InVehicle", function ()
        local pid = selectedPlayer
        local vehicle = player.get_vehicle_handle(pid)
        if vehicle == 0 then return end
        local coords = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        for seat = -1, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(vehicle)) - 1 do
            if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, seat, false) then
                features.teleport(coords)
                PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, seat)
                return
            end
        end
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Teleport vehicle to me", "BS_PlayerList_Player_Teleport_VehToMe", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0.0, 5.0, 0.0)
        features.teleport(vehicle, coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Parachute to", "BS_PlayerList_Player_Teleport_Parachute", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player.get_entity_handle(pid), 0.0, 0.0, 150.0)
        features.teleport(coords)
    end):setConfigIgnore()
    PlayerTeleport:add_click_option("Enter player's interior", "BS_PlayerList_Player_Teleport_Interior", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not player.is_in_interior(pid) then return end
        local interior = player.get_interior_handle(pid)
        player.teleport_to_interior(player.index(), interior)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Teleport", "BS_PlayerList_Teleport", PlayerTeleport)
    table.insert(submenus, PlayerTeleport)
end

PlayerVehicle = Submenu.add_static_submenu("Vehicle", "BS_PlayerList_Player_Vehicle") do
    PlayerVehicle:add_bool_option("Attach to my vehicle", "BS_PlayerList_Player_Vehicle_VehicleAttach", function(state, option)
        local base = player.get_vehicle_handle(player.index())
        if base == 0 then
            notify.warning("Interactions", "You're not in a vehicle.")
            return option:setValue(false, true)
        end
        local target = player.get_vehicle_handle(selectedPlayer)
        if target == 0 then
            notify.warning("Interactions", "Player is not in a vehicle.")
            return option:setValue(false, true)
        end
        if target == base then return end
        entity.request_control(target, function(hdl)
            if state then
                ENTITY.ATTACH_ENTITY_TO_ENTITY(hdl, base, 0, 0.0, -5.0, 0.0, 0.0, 0.0, 0.0, false, true, true, false, 0, true, false)
            else
                ENTITY.DETACH_ENTITY(hdl, false, false)
            end
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_choose_option("Attach ramp", "BS_PlayerList_Player_Vehicle_AttachRamp", false, {"Detach & delete", "Small ramp", "Big ramp"}, function(pos)
        local vehicle = player.get_vehicle_handle(selectedPlayer)
        if vehicle == 0 then
            notify.warning("Interactions", "Player is not in a vehicle.")
            return
        end
        local coords = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        local hash = string.joaat("prop_mp_ramp_01")
        if pos == 3 then hash = string.joaat("prop_mp_ramp_03") end
        callbacks.requestModel(hash, function()		
            if pos > 1 then
                entity.spawn_obj(hash, coords, function (ramp)                    
                    table.insert(Stuff.ramps, ramp)
                    entity.request_control(vehicle, function(hdl)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(ramp, hdl, 0, 0.0, 8.0, 0.0, 0.0, 0.0, 180.0, false, true, true, false, 0, true, false)
                    end)
                end)
            else
                for _, ramp in ipairs(Stuff.ramps) do
                    entity.delete(ramp)
                end
            end
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Kick from vehicle", "BS_PlayerList_Player_Vehicle_VehicleKick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        player.vehicle_kick(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Disown vehicle", "BS_PlayerList_Player_Vehicle_Disown", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        player.vehicle_disown(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Disable vehicle", "BS_PlayerList_Player_Vehicle_Disable", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        script.send(pid, -513394492, pid)
        script.send(pid, -852914485, 0, 0, 0, 0, 1, 2000000000)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Send EMP", "BS_PlayerList_Player_Vehicle_EMP", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        player.vehicle_emp(pid)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Rotate 180", "BS_PlayerList_Player_Vehicle_Rotate180", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 5)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_ROTATION(hdl, rotation.x + 180, rotation.y, rotation.z, 5, true)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Freeze", "BS_PlayerList_Player_Vehicle_Freeze", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.FREEZE_ENTITY_POSITION(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_choose_option("Boost", "BS_PlayerList_Player_Vehicle_Boost", false, {"Forward", "Back", "Right", "Left", "Up", "Down"}, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        addActiveAction(pid, option, value)
        local vehicle = player.get_vehicle_handle(pid)
        local force = 10.0
        local vector = {
            x = value == 1 and force or value == 2 and -force or 0.0,
            y = value == 3 and force or value == 4 and -force or 0.0,
            z = value == 5 and force or value == 6 and -force or 0.0
        }
        entity.request_control(vehicle, function (hdl)
            ENTITY.APPLY_FORCE_TO_ENTITY(hdl, 1, vector.x, vector.y, vector.z, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_choose_option("Upgrade", "BS_PlayerList_Player_Vehicle_Upgrade", false, {"Default", "Random", "Power", "Max"}, function (pos, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        addActiveAction(pid, option, pos)
        local vehicle = player.get_vehicle_handle(pid)
        features.setVehiclePreset(vehicle, pos)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Burst tyres", "BS_PlayerList_Player_Vehicle_BurstTyres", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_INVINCIBLE(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Revive engine", "BS_PlayerList_Player_Vehicle_ReviveEngine", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_FIXED(hdl)
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(hdl, 0.0)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Repair shell", "BS_PlayerList_Player_Vehicle_RepairShell", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(hdl)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Enable alarm", "BS_PlayerList_Player_Vehicle_Alarm", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_ALARM(hdl, state)
        end)
    end):setConfigIgnore()
    PlayerVehicle:add_bool_option("Lock vehicle", "BS_PlayerList_Player_Vehicle_Lock", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
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
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 1, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Brake + Reverse", "BS_PlayerList_Player_Vehicle_RVC_BrakeReverse", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 3, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Brake + Strong Reverse", "BS_PlayerList_Player_Vehicle_RVC_BrakeStrongReverse", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 28, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Turn Left + Accelerate", "BS_PlayerList_Player_Vehicle_RVC_TurnLeft", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 7, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Turn Right + Accelerate", "BS_PlayerList_Player_Vehicle_RVC_TurnRight", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 8, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Accelerate", "BS_PlayerList_Player_Vehicle_RVC_Accelerate", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 23, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Strong Accelerate", "BS_PlayerList_Player_Vehicle_RVC_StrongAccelerate", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 32, task_time)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Spin Forever", "BS_PlayerList_Player_Vehicle_RVC_SpinForever", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 7, 2147483647)
    end):setConfigIgnore()
    PlayerVehicle:add_click_option("Stop Forever", "BS_PlayerList_Player_Vehicle_RVC_StopForever", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(player.get_entity_handle(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        TASK.TASK_VEHICLE_TEMP_ACTION(player.get_entity_handle(pid), vehicle, 1, 2147483647)
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Vehicle", "BS_PlayerList_Player_Vehicle", PlayerVehicle)
    table.insert(submenus, PlayerVehicle)
end

local kickvalues = {
    "H", "SE", "SEN", "IDM"
}

local crashvalues = {
    "SE", "SEN", "VT", "AC", "AA"
}

PlayerRemovals = Submenu.add_static_submenu("Removals", "BS_PlayerList_Player_Removals") do
    PlayerRemovals:add_choose_option("Kick", "BS_PlayerList_Player_Removals_Kick", false, kickvalues, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        addActiveAction(pid, option, value)
        pussy_func(pid, 30, "Manual | Kick [" .. kickvalues[value] .. "]")
        if value == 1 then player.kick(pid) end
        if value == 2 then player.kick_brute(pid) end
        if value == 3 then scripts.events.notifKick(pid) end
        if value == 4 then player.kick_idm(pid) end
    end):setConfigIgnore()
    PlayerRemovals:add_choose_option("Crash", "BS_PlayerList_Player_Removals_Crash", false, crashvalues, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local ped = player.get_entity_handle(pid)
        addActiveAction(pid, option, value)
        pussy_func(pid, 30, "Manual | Crash [" .. crashvalues[value] .. "]")
        if value == 1 then
            scripts.events.crash(pid)
        elseif value == 2 then
            scripts.events.notifCrash(pid)
        elseif value == 3 then
            do
                local vehicle = player.get_vehicle_handle(pid)
                if vehicle == 0 then
                    notify.warning("Interactions", "Player is not in a vehicle")
                    return
                end
                for val = 16, 18 do
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, vehicle, val, 1488)
                end
            end
        elseif value == 4 or value == 5 then
            local coords = ENTITY.GET_ENTITY_COORDS(ped, false)
            if coords.z == -50 then
                notify.warning("Interactions", "Player is out of render distance")
                return
            end
            local hashes = {2633113103, 3471458123, 630371791, 3602674979, 3852654278}
            if value == 4 then
                hashes = {390902130, -1881846085}
            end
            local spawnedVehs = {}
            for i = 1, #hashes do
                callbacks.requestModel(hashes[i], function ()
                    entity.spawn_veh(hashes[i], coords, function (veh)
                        spawnedVehs[i] = veh
                    end)
                end)
            end
            if value == 4 then
                for i = 1, #hashes do
                    ENTITY.ATTACH_ENTITY_TO_ENTITY(spawnedVehs[i], ped, 0, 0.0, 0.0, 0.0, math.random(0.0, 180.0), math.random(0.0, 180.0), math.random(0.0, 180.0), false, true, true, false, 0, true, false)
                end
            else
                for i = 1, #hashes do
                    ENTITY.ATTACH_ENTITY_TO_ENTITY(spawnedVehs[i], spawnedVehs[#hashes], 0, 0.0, 8.0, 0.0, math.random(0.0, 180.0), math.random(0.0, 180.0), math.random(0.0, 180.0), false, true, true, false, 0, true, false)
                end
                ENTITY.ATTACH_ENTITY_TO_ENTITY(spawnedVehs[#hashes], ped, 0, 0.0, 0.0, 0.0, math.random(0.0, 180.0), math.random(0.0, 180.0), math.random(0.0, 180.0), false, true, true, false, 0, true, false)
            end
        end
    end):setConfigIgnore()
    PlayerInteractions:add_sub_option("Removals", "BS_PlayerList_Player_Removals", PlayerRemovals)
    table.insert(submenus, PlayerRemovals)
end

PlayerBlocks = Submenu.add_static_submenu("Block", "BS_PlayerList_Player_Block") do
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
    PlayerInteractions:add_sub_option("Block", "BS_PlayerList_Player_Block", PlayerBlocks)
    table.insert(submenus, PlayerBlocks)
end

PlayerNeutral = Submenu.add_static_submenu("Neutral", "BS_Players_Neutral") do
    PlayerNeutral:add_click_option("Copy outfit", "BS_Players_Neutral_CopyOutfit", function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        local ped = player.get_entity_handle(pid)
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
    PlayerInteractions:add_sub_option("Neutral", "BS_Players_Neutral", PlayerNeutral)
end

local bountyvalues = {
    "1000", "2000", "3000",
    "4000", "5000", "6000",
    "7000", "8000", "9000",
    "10000", "1", "1337",
    "69", "6969", "1488"
}
PlayerGriefing = Submenu.add_static_submenu("Griefing", "BS_PlayerList_Player_Griefing") do
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
    PlayerGriefing:add_choose_option("Set bounty", "BS_PlayerList_Player_Griefing_SetBounty", false, bountyvalues, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        addActiveAction(pid, option, value)
        player.set_bounty(pid, tonumber(bountyvalues[value]), true)
    end):setConfigIgnore()
    PlayerGriefing:add_choose_option("Passive mode", "BS_PlayerList_Player_Griefing_PassiveMode", false, {"Unblock", "Block"}, function (value, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        addActiveAction(pid, option, value)
        scripts.events.passiveMode(pid, 1 - value)
    end):setConfigIgnore()
    local optionNotifSpam
    optionNotifSpam = PlayerGriefing:add_looped_option("Notification spam", "BS_Players_Neutral_NotifSpam", 1.0, function ()
        local pid = selectedPlayer
        if not player.is_connected(pid) then return end
        scripts.events.sendRandomNotif(pid)
        addActiveAction(pid, optionNotifSpam, true)
    end, function()
        local pid = selectedPlayer
        addActiveAction(pid, optionNotifSpam, false)
    end):setConfigIgnore()
    do
        local invCage = false
        local spawnedCages = {}
        local cageActList = {"Spawn cable car", "Spawn stunt tube", "Spawn fence", "Remove"}
        PlayerGriefing:add_separator("Cages", "BS_PlayerList_Player_Griefing_Cages")
        PlayerGriefing:add_bool_option("Invisible", "BS_PlayerList_Player_Griefing_CagesInvisible", function (state)
            invCage = state
        end):setConfigIgnore()
        PlayerGriefing:add_choose_option("Action", "BS_PlayerList_Player_Griefing_CagesAction", false, cageActList, function (pos)
            local pid = GetSelectedPlayer()
            local ped = player.get_entity_handle(pid)
            local coords = ENTITY.GET_ENTITY_COORDS(ped, false)
            coords.z = coords.z - 0.9
            local hashes = {
                string.joaat("cablecar"),
                string.joaat("stt_prop_stunt_tube_s"),
                string.joaat("prop_fnclink_03e")
            }
            switch(cages[pos], {
                ["Spawn cable car"] = function()
                    for i = 1, 4 do
                        entity.spawn_veh(hashes[pos], coords, function (handle)
                            table.insert(spawnedCages, handle)
                            ENTITY.FREEZE_ENTITY_POSITION(handle, true)
                            ENTITY.SET_ENTITY_VISIBLE(handle, not invCage)
                            if table.contains({3, 4}, i) then
                                local rot = ENTITY.GET_ENTITY_ROTATION(handle, 5)
                                ENTITY.SET_ENTITY_ROTATION(handle, rot.x, rot.y, -90.0, 5, true)
                            end
                        end)
                    end
                    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hashes[pos])
                end,
                ["Spawn stunt tube"] = function()
                    callbacks.requestModel(hashes[pos], function ()
                        entity.spawn_obj(hashes[pos], coords, function (handle)
                            table.insert(spawnedCages, handle)
                            local rot = ENTITY.GET_ENTITY_ROTATION(handle, 5)
                            ENTITY.SET_ENTITY_ROTATION(handle, rot.x, 90.0, rot.z, 5, true)
                            ENTITY.FREEZE_ENTITY_POSITION(handle, true)
                            ENTITY.SET_ENTITY_VISIBLE(handle, not invCage)
                        end)
                    end)
                    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hashes[pos])
                end,
                ["Spawn fence"] = function()
                    local fX = {coords.x-1.5, coords.x-1.5, coords.x+1.5, coords.x-1.5}
                    local fY = {coords.y+1.5, coords.y-1.5, coords.y+1.5, coords.y+1.5}
                    for i = 1, 4 do
                        coords.x = fX[i]
                        coords.y = fY[i]
                        entity.spawn_obj(hashes[pos], coords, function (handle)
                            table.insert(spawnedCages, handle)
                            ENTITY.FREEZE_ENTITY_POSITION(handle, true)
                            ENTITY.SET_ENTITY_VISIBLE(handle, not invCage)
                            if table.contains({3, 4}, i) then
                                local rot = ENTITY.GET_ENTITY_ROTATION(handle, 5)
                                ENTITY.SET_ENTITY_ROTATION(handle, rot.x, rot.y, -90.0, 5, true)
                            end
                        end)
                    end
                end
            }, function()
                for _, handle in ipairs(spawnedCages) do
                    if not features.isEmpty(handle) then
                        entity.delete(handle)
                    end
                end
                spawnedCages = {}
            end)
        end):setConfigIgnore()
    end
    do
        PlayerGriefing:add_separator("Attackers", "BS_PlayerList_Player_Griefing_Attackers")
        local attackersSettings = Submenu.add_static_submenu("Settings", "BS_PlayerList_Griefing_Attackers_Settings")
        local config = {
            weapon = 2725352035,
            count = 1,
            godmode = false,
            group = nil,
        }
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
        local variations = {"None", "Pistol", "AK-74", "M4", "M16", "MG", "Shotgun", "RPG"}
        attackersSettings:add_choose_option("Weapon", "BS_PlayerList_Griefing_Attackers_Settings_Weapon", true, variations, function (pos)
            config.weapon = weapons[variations[pos]]
        end)
        attackersSettings:add_num_option("Count", "BS_PlayerList_Griefing_Attackers_Settings_Count", 1, 30, 1, function (pos)
            config.count = pos
        end):setValue(1, true)
        attackersSettings:add_bool_option("Invincibility", "BS_PlayerList_Griefing_Attackers_Settings_GodMode", function (state)
            config.godmode = state
        end)
        attackersSettings:add_click_option("Clear all attackers", "BS_PlayerList_Griefing_Attackers_Settings_ClearAll", function ()
            local cnt = #Stuff.attackers
            for _, ped in ipairs(Stuff.attackers) do
                entity.delete(ped)
            end
            Stuff.attackers = {}
            notify.success("Attackers", "Successfully removed " .. cnt .. " attackers.")
        end)
        PlayerGriefing:add_sub_option("Settings", "BS_PlayerList_Griefing_Attackers_Settings", attackersSettings)
        PlayerGriefing:add_choose_option("NPCs", "BS_PlayerList_Player_Griefing_SendPed", false, {"Super-hero", "Jesus", "Drunk Russian", "Mime"}, function (pos, option)
            local hash = pos == 1 and "u_m_y_imporage" or pos == 2 and "u_m_m_jesus_01" or pos == 3 and "IG_RussianDrunk" or pos == 4 and "s_m_y_mime"
            hash = string.joaat(hash)
            local playerPed = player.get_entity_handle(selectedPlayer)
            if task.exists("BS_PlayerList_Player_Griefing_SendPed") then notify.warning("Attackers", "The script hasn't finished previous attacker sending yet.\nTry again later.") return end
            task.createTask("BS_PlayerList_Player_Griefing_SendPed", 0.1, config.count, function ()                
                callbacks.requestModel(hash, function()
                    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, math.random(-10, 10) + .0, math.random(-10, 10)+ .0, 0.0)
                    entity.spawn_ped(hash, coords, function (attacker)
                        table.insert(Stuff.attackers, attacker)
                        if not config.group then
                            config.group = PED.CREATE_GROUP(0)
                            PED.SET_PED_AS_GROUP_LEADER(attacker, config.group)
                        end
                        PED.SET_PED_AS_GROUP_MEMBER(attacker, config.group)
                        if config.godmode then
                            ENTITY.SET_ENTITY_INVINCIBLE(attacker, true)
                        end
                        TASK.TASK_COMBAT_PED(attacker, playerPed, 0, 16)
                        PED.SET_PED_ACCURACY(attacker, 100.0)
                        PED.SET_PED_COMBAT_ABILITY(attacker, 2)
                        PED.SET_PED_AS_ENEMY(attacker, true)
                        PED.SET_PED_ARMOUR(attacker, 200)
                        PED.SET_PED_MAX_HEALTH(attacker, 10000)
                        ENTITY.SET_ENTITY_HEALTH(attacker, 10000, 0)
                        PED.SET_PED_FLEE_ATTRIBUTES(attacker, 0, false)
                        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 46, true)
                        WEAPON.GIVE_WEAPON_TO_PED(attacker, config.weapon, 0, false, true)
                    end)
                end)
            end)
            addActiveAction(selectedPlayer, option, pos)
        end):setConfigIgnore()
        PlayerGriefing:add_choose_option("Animals", "BS_PlayerList_Player_Griefing_SendAnimal", false, {"Shepherd", "Husky", "Chop"}, function (pos, option)            
            local hash = pos == 1 and "A_C_shepherd" or pos == 2 and "A_C_Husky" or pos == 3 and "A_C_Chop"
            hash = string.joaat(hash)
            local playerPed = player.get_entity_handle(selectedPlayer)
            if task.exists("BS_PlayerList_Player_Griefing_SendAnimal") then notify.warning("Attackers", "The script hasn't finished previous attacker sending yet.\nTry again later.") return end
            task.createTask("BS_PlayerList_Player_Griefing_SendAnimal", 0.1, config.count, function ()
                callbacks.requestModel(hash, function()
                    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, math.random(-10, 10) + .0, math.random(-10, 10)+ .0, 0.0)
                    entity.spawn_ped(hash, coords, function (attacker)
                        table.insert(Stuff.attackers, attacker)
                        if config.godmode then
                            ENTITY.SET_ENTITY_INVINCIBLE(attacker, true)
                        end
                        TASK.TASK_COMBAT_PED(attacker, playerPed, 0, 16)
                        PED.SET_PED_ACCURACY(attacker, 100.0)
                        PED.SET_PED_COMBAT_ABILITY(attacker, 2)
                        PED.SET_PED_AS_ENEMY(attacker, true)
                        PED.SET_PED_MAX_HEALTH(attacker, 10000)
                        ENTITY.SET_ENTITY_HEALTH(attacker, 10000, 0)
                    end)
                end)
            end)
            addActiveAction(selectedPlayer, option, pos)
        end):setConfigIgnore()
        PlayerGriefing:add_choose_option("Jets", "BS_PlayerList_Player_Griefing_SendJets", false, {"B-11 Strikeforce", "Lazer", "UFO"}, function (pos, option)            
            local hash = pos == 1 and "strikeforce" or pos == 2 and "Lazer" or pos == 3 and "strikeforce"
            hash = string.joaat(hash)
            local playerPed = player.get_entity_handle(selectedPlayer)
            if task.exists("BS_PlayerList_Player_Griefing_SendJets") then notify.warning("Attackers", "The script hasn't finished previous attacker sending yet.\nTry again later.") return end
            task.createTask("BS_PlayerList_Player_Griefing_SendJets", 0.1, config.count, function ()                
                callbacks.requestModel(hash, function()
                    callbacks.requestModel(-163714847, function()
                        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, math.random(-50, 50) + .0,  math.random(-50, 50) + .0, 150.0)
                        entity.spawn_veh(hash, coords, function (aircraft)
                            table.insert(Stuff.attackers, aircraft)
                            VEHICLE.CONTROL_LANDING_GEAR(aircraft, 3)
                            VEHICLE.SET_HELI_BLADES_FULL_SPEED(aircraft)
                            VEHICLE.SET_VEHICLE_FORWARD_SPEED(aircraft, VEHICLE.GET_VEHICLE_ESTIMATED_MAX_SPEED(aircraft))
                            if config.godmode then
                                ENTITY.SET_ENTITY_INVINCIBLE(aircraft, true)
                            end
                            for i = -1, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash) - 2 do
                                entity.spawn_ped(-163714847, coords, function (ped)
                                    table.insert(Stuff.attackers, ped)
                                    if i == -1 then
                                        TASK.TASK_PLANE_MISSION(ped, aircraft, 0, playerPed, 0.0, 0.0, 0.0, 6, 0.0, 0.0, 0.0, 50.0, 40.0, true)
                                    end
                                    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
                                    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
                                    PED.SET_PED_INTO_VEHICLE(ped, aircraft, i)
                                    TASK.TASK_COMBAT_PED(ped, playerPed, 0, 16)
                                    PED.SET_PED_COMBAT_ABILITY(ped, 2)
                                    PED.SET_PED_ACCURACY(ped, 100.0)
                                    PED.SET_PED_ARMOUR(ped, 200)
                                    PED.SET_PED_MAX_HEALTH(ped, 1000)
                                    ENTITY.SET_ENTITY_HEALTH(ped, 1000, 0)
                                    if pos == 3 then
                                        local ufoHash = string.joaat("p_spinning_anus_s")
                                        callbacks.requestModel(ufoHash, function()
                                            entity.spawn_obj(ufoHash, coords, function (spawnedUfo)
                                                table.insert(Stuff.attackers, spawnedUfo)
                                                ENTITY.SET_ENTITY_COLLISION(spawnedUfo, false, false)
                                                ENTITY.SET_ENTITY_VISIBLE(aircraft, false, false)
                                                ENTITY.ATTACH_ENTITY_TO_ENTITY(spawnedUfo, aircraft, 0, 0.0, 0.0, 5.0, 0.0, 0.0, 0, true, true, false, false, 0, true)
                                            end)
                                        end)
                                    end
                                end)
                            end
                        end)
                    end)
                end)
            end)
            addActiveAction(selectedPlayer, option, pos)
        end):setConfigIgnore()
        PlayerGriefing:add_choose_option("Tanks", "BS_PlayerList_Player_Griefing_SendTank", false, {"APC", "Rhino"}, function (pos, option)            
            local hash = pos == 1 and "apc" or pos == 2 and "RHINO"
            hash = string.joaat(hash)
            local playerPed = player.get_entity_handle(selectedPlayer)
            if task.exists("BS_PlayerList_Player_Griefing_SendTank") then notify.warning("Attackers", "The script hasn't finished previous attacker sending yet.\nTry again later.") return end
            task.createTask("BS_PlayerList_Player_Griefing_SendTank", 0.1, config.count, function ()                
                callbacks.requestModel(hash, function()
                    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, math.random(-10, 10) + .0, math.random(-10, 10)+ .0, 0.0)
                    entity.spawn_veh(hash, coords, function (tank)
                        local group = nil
                        table.insert(Stuff.attackers, tank)
                        for i = -1, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash) - 2 do
                            entity.spawn_ped(-163714847, coords, function (driver)
                                if not group then
                                    group = PED.CREATE_GROUP(0)
                                    PED.SET_PED_AS_GROUP_LEADER(driver, group)
                                end
                                PED.SET_PED_AS_GROUP_MEMBER(driver, group)
                                table.insert(Stuff.attackers, driver)
                                if i == -1 then
                                    TASK.TASK_VEHICLE_CHASE(driver, playerPed)
                                end
                                PED.SET_PED_INTO_VEHICLE(driver, tank, i)
                                WEAPON.GIVE_WEAPON_TO_PED(driver, config.weapon, 1000, false, true)
                                PED.SET_PED_COMBAT_ATTRIBUTES(driver, 5, true)
                                PED.SET_PED_COMBAT_ATTRIBUTES(driver, 46, true)
                                TASK.TASK_COMBAT_PED(driver, playerPed, 0, 16)
                                if config.godmode then
                                    ENTITY.SET_ENTITY_INVINCIBLE(tank, true)
                                    ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
                                end
                            end)
                        end
                    end)
                end)
            end)
            addActiveAction(selectedPlayer, option, pos)
        end):setConfigIgnore()
    end
    PlayerInteractions:add_sub_option("Griefing", "BS_PlayerList_Griefing", PlayerGriefing)
    table.insert(submenus, PlayerGriefing)
    
end

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
    if player.is_banned(pid) then table.insert(out, {"[B]", 0, 204, 255}) end
    if player.is_next_host(pid) then table.insert(out, {"[NS]", 107, 223, 227}) end
    return out
end

local function sort() end

PlayerList = Submenu.add_dynamic_submenu("Players list", "BS_PlayerList", function (sub)
    local options = {}
    for pid = 0, 32 do
        if player.is_connected(pid) then
            table.insert(options, PlayerList:add_sub_option(player.get_name(pid), "Player_" .. pid, PlayerInteractions, function ()
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
            end):setTags(getPlayerFlags(pid)):setValue(pid, true))
        else
            activeActions[pid + 1] = nil
        end
    end
    table.sort(options, sort)
    table.insert(options, 1, sub.options[1]) -- For sort option
    sub.options = options
end)

PlayerList:add_choose_option("Sort", "BS_PlayerList_Sort", true, {"Name", "Distance", "Host queue", "Join time"}, function (pos, option)
    if pos == 1 then
        sort = function (a, b)
            return a:getName():lower() < b:getName():lower()
        end
    elseif pos == 2 then
        sort = function (a, b)
            local pid1, pid2 = a:getValue(), b:getValue()
            return player.get_distance(pid1) < player.get_distance(pid2)
        end
    elseif pos == 3 then
        sort = function (a, b)
            local pid1, pid2 = a:getValue(), b:getValue()
            return player.get_host_priority(pid1) < player.get_host_priority(pid2)
        end
    elseif pos == 4 then
        sort = function (a, b)
            local pid1, pid2 = a:getValue(), b:getValue()
            return player.get_join_time(pid1) < player.get_join_time(pid2)
        end
    end
end):setStatic(true)

Main:add_sub_option("Players", "BS_PlayerList", PlayerList)

PlayerInteractions:add_click_option("Copy info", "BS_Players_Info_CopyInfo", function ()
    local pid = selectedPlayer
    if not player.is_connected(pid) then return end
    local out = string.format("Player info\nName: %s\nRID: %i\nIP: %s", player.get_name(pid), player.get_rid(pid), player.get_ip_string(pid))
    utils.set_clipboard(out)
    notify.success("Players", "Copied player info to clipboard.")
end)

task.createTask("Ckeck_Players_On_Leaving", 0.0, nil, function ()
    if player.is_connected(GetSelectedPlayer()) then return end
    for _, sub in ipairs(submenus) do
        if sub:isOpened() then
            sub:setActive(false)
        end
    end
    activeActions[selectedPlayer + 1] = nil
    selectedPlayer = -1
end)

-- END