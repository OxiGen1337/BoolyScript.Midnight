local gui = require("BoolyScript/globals/gui")
require("BoolyScript/system/events_listener")
require("BoolyScript/util/notify_system")
local scripts = require("BoolyScript/rage/scripts")
local features = require("BoolyScript/rage/features")

local players = {}
local connectedPlayers = {}

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

PlayerTeleport = Submenu.add_static_submenu("Teleport", "BS_PlayerList_Player_Teleport_Submenu") do
    PlayerTeleport:add_click_option("Teleport to player", "BS_PlayerList_Player_Teleport_ToPlayer", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
        utils.teleport(coords)
    end)
    PlayerTeleport:add_click_option("Teleport in vehicle", "BS_PlayerList_Player_Teleport_InVehicle", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        for seat = -1, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(string.joaat(ENTITY.GET_ENTITY_MODEL(vehicle))) - 1 do
            if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, seat, false) then
                utils.teleport(coords)
                PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, seat)
                return
            end
        end
    end)
    PlayerTeleport:add_click_option("Teleport vehicle to me", "BS_PlayerList_Player_Teleport_VehToMe", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0.0, 5.0, 0.0)
        utils.teleport(vehicle, coords)
    end)
    PlayerTeleport:add_click_option("Parachute to", "BS_PlayerList_Player_Teleport_Parachute", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0.0, 0.0, 150.0)
        utils.teleport(coords)
    end)
    PlayerTeleport:add_click_option("Enter player's interior", "BS_PlayerList_Player_Teleport_Interior", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not player.is_in_interior(pid) then return end
        local interior = player.get_interior_handle(pid)
        player.teleport_to_interior(player.index(), interior)
    end)
    PlayerInteractions:add_sub_option("Teleport", "BS_PlayerList_Teleport_SubOption", PlayerTeleport)
    table.insert(submenus, PlayerTeleport)
end

PlayerVehicle = Submenu.add_static_submenu("Vehicle", "BS_PlayerList_Player_Vehicle_Submenu") do
    PlayerVehicle:add_click_option("Kick from vehicle", "BS_PlayerList_Player_Vehicle_VehicleKick", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        player.vehicle_kick(pid)
    end)
    PlayerVehicle:add_click_option("Rotate 180", "BS_PlayerList_Player_Vehicle_Rotate180", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 5)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_ROTATION(hdl, rotation.x + 180, rotation.y, rotation.z, 5, true)
        end)
    end)
    PlayerVehicle:add_bool_option("Freeze", "BS_PlayerList_Player_Vehicle_Freeze", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.FREEZE_ENTITY_POSITION(hdl, state)
        end)
    end)
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
    end)
    PlayerVehicle:add_choose_option("Upgrade", "BS_PlayerList_Player_Vehicle_Upgrade", false, {"Default", "Random", "Power", "Max"}, function (pos, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, pos)
        local vehicle = player.get_vehicle_handle(pid)
        features.setVehiclePreset(vehicle, pos)
    end)
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
    end)
    PlayerVehicle:add_bool_option("Invincible", "BS_PlayerList_Player_Vehicle_Godmode", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            ENTITY.SET_ENTITY_INVINCIBLE(hdl, state)
        end)
    end)
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
    end)
    PlayerVehicle:add_click_option("Repair & wash", "BS_PlayerList_Player_Vehicle_Repair", function ()
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_FIXED(hdl)
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(hdl, 0.0)
        end)
    end)
    PlayerVehicle:add_bool_option("Enable alarm", "BS_PlayerList_Player_Vehicle_Alarm", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_ALARM(hdl, state)
        end)
    end)
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
    end)
    PlayerVehicle:add_bool_option("Disable gravity", "BS_PlayerList_Player_Vehicle_NoGravity", function (state, option)
        local pid = selectedPlayer
        if not pid or not player.is_connected(pid) then return end
        if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false) then return end
        addActiveAction(pid, option, state)
        local vehicle = player.get_vehicle_handle(pid)
        entity.request_control(vehicle, function (hdl)
            VEHICLE.SET_VEHICLE_GRAVITY(hdl, not state)
        end)
    end)
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
    end)
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
    end)
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
    end)
    PlayerInteractions:add_sub_option("Block", "BS_PlayerList_Player_Block_SubOption", PlayerBlocks)
    table.insert(submenus, PlayerBlocks)
end

-- PlayerGriefing = Submenu.add_static_submenu("Griefing", "BS_PlayerList_Griefing_Submenu") do
--     -- PlayerGriefing:add_click_option("tt", "", function ()
--     --     local pid = selectedPlayer
--     --     if not pid or not player.is_connected(pid) then return end
--     --     print(player.send_sms(pid, "ggggg"))
--     -- end)
--     PlayerGriefing:add_click_option()
--     PlayerInteractions:add_sub_option("Griefing", "BS_PlayerList_Player_Griefing_SubOption", PlayerGriefing)
--     table.insert(submenus, PlayerGriefing)
-- end


for pid = 0, 32 do
    local option = setmetatable({}, Option)
    option.ID = #players + 1
    option.name = "PID: " .. pid
    option.type = OPTIONS.SUB
    option.hash = "PlayerList_" .. pid
    option.value = pid
    option.callback = function ()
        selectedPlayer = pid
        PlayerInteractions:setActive(true)
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
    end
    table.insert(players, option)
end

local function getPlayerFlags(pid)
    if not player.is_connected(pid) then return "" end
    local out = ""
    if player.is_local(pid) then out = out .. "[ME] " end
    if player.is_god(pid) then out = out .. "[G] " end
    if player.is_script_host(pid) then out = out .. "[SH] " end
    if player.is_session_host(pid) then out = out .. "[H] " end
    if player.is_in_interior(pid) then out = out .. "[I] " end    
    if player.is_in_vehicle(pid) then out = out .. "[V] " end
    if player.is_in_cutscene(pid) then out = out .. "[CS] " end
    if player.is_modder(pid) then out = out .. "[M] " end
    if player.is_friend(pid) then out = out .. "[F] " end
    return out
end

PlayerList = Submenu.add_dynamic_submenu("Players list", "BS_PlayerList_Submenu", 
    function ()
        connectedPlayers = {}
        for pid = 0, 32 do
            if player.is_connected(pid) then
                table.insert(connectedPlayers, players[pid+1])
                connectedPlayers[#connectedPlayers].name = player.get_name(pid) .. " " .. getPlayerFlags(pid)
            else
                activeActions[pid + 1] = nil
            end
        end
        return #connectedPlayers
    end,
    function (i)
        return connectedPlayers[i]
    end)

Main:add_sub_option("Players", "BS_PlayerList_SubOption", PlayerList)


-- local playerList = menu.add_combo_ex(self, "Player list", "BS_Players_PLayerList", function (_, index)
--     local player_m = connectedPlayers[index]
--     return string.format("%i. %s", player_m.pid, player_m.name)
-- end, function ()
--     return #connectedPlayers
-- end)

-- function getSelectedPlayer()
--     local comboVal = playerList:get_long()
--     local player_m = connectedPlayers[comboVal]
--     if player_m == nil then return -1 end
--     return player_m
-- end

-- menu.add_checkbox(self, "Check players GeoIP", "BS_Players_CheckGeoIP", function (_, state)
--     local listName = "BS_Players_CheckGeoIP"
--     if state then
--         listener.register(listName, GET_EVENTS_LIST().OnPlayerActive, function (pid)
--             local ip = player.get_ip_string(pid)
--             http.get("http://ip-api.com/json/"..ip, function (code, _, rawContent)
--                 if code == 200 then
--                     local content = json.decode(rawContent)
--                     playersGeoIP[pid] = string.format("%s, %s", content["countryCode"], content["city"])
--                 else
--                     log.error("HTTP", string.format("Failed to get GeoIP | Error code: %i", code))
--                 end
--             end)
--         end)
--     elseif listener.exists(listName) then
--         listener.remove(listName)
--     end
-- end)

-- menu.add_dynamic_text(self, "BS_Players_Info", function ()
--     local player_m = getSelectedPlayer()
--     return string.format("Player info\nName: %s\nRID: %i\nIP: %s\nGeoIP: %s", player_m.name, player_m.rid, player_m.ip, player_m.GeoIP)
-- end)

-- menu.add_button(self, "Copy info", "BS_Players_Info_CopyInfo", function ()
--     local player_m = getSelectedPlayer()
--     if not player.is_connected(player_m.pid) then return end
--     local out = string.format("Player info\nName: %s\nRID: %i\nIP: %s\nGeoIP: %s", player_m.name, player_m.rid, player_m.ip, player_m.GeoIP)
--     utils.set_clipboard(out)
--     notify.success("Players", "Copied player info into your clipboard.", gui.icons.players)
-- end)

-- menu.add_static_text(self, "Removals", "BS_Players_Removals")

-- menu.add_button(self, "IDM kick", "BS_Players_Removals_Kick", function ()
--     local player_m = getSelectedPlayer()
--     if not player.is_connected(player_m.pid) then return end
--     player.kick_idm(player_m.pid)
-- end)

-- menu.add_button(self, "SE crash", "BS_Players_Removals_Crash", function ()
--     local player_m = getSelectedPlayer()
--     if not player.is_connected(player_m.pid) then return end
--     scripts.events.crash(player_m.pid)
-- end)

-- menu.add_static_text(self, "Neutral", "BS_Players_Neutral")

-- menu.add_button(self, "Copy outfit", "BS_Players_Neutral_CopyOutfit", function ()
--     local player_m = getSelectedPlayer()
--     if not player.is_connected(player_m.pid) then return end
--     local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_m.pid)
--     for i = 0, 11 do
-- 		PED.SET_PED_COMPONENT_VARIATION(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_DRAWABLE_VARIATION(ped, i), PED.GET_PED_TEXTURE_VARIATION(ped, i), PED.GET_PED_PALETTE_VARIATION(ped, i))
-- 	end
-- 	for i = 0, 7 do
--         if PED.GET_PED_PROP_INDEX(ped, i) >= 0 and PED.GET_PED_PROP_TEXTURE_INDEX(ped, i) >= 0 then
-- 		    PED.SET_PED_PROP_INDEX(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_PROP_INDEX(ped, i), PED.GET_PED_PROP_TEXTURE_INDEX(ped, i), true)
--         end
-- 	end
-- end)

-- menu.add_button(self, "Teleport (Me -> Player)", "BS_Players_Neutral_TeleportMeToPlayer", function ()
--     local player_m = getSelectedPlayer()
--     if not player.is_connected(player_m.pid) then return end
--     local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_m.pid)
--     local playerCoords = ENTITY.GET_ENTITY_COORDS(ped, true)
--     utils.teleport(playerCoords)
-- end)

-- END