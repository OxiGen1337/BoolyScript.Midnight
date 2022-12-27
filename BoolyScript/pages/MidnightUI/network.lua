require("BoolyScript/util/menu")
local filesys = require("BoolyScript/util/file_system")
local paths = require("BoolyScript/globals/paths")
require("BoolyScript/globals/stuff")
require("BoolyScript/system/events_listener")
require("BoolyScript/util/notify_system")
local scripts = require("BoolyScript/rage/scripts")
--require("BoolyScript/util/parse")

local page = GET_PAGES()['BS_Main']
local self = menu.add_mono_block(page, "Network", "BS_Network", BLOCK_ALIGN_RIGHT)

menu.add_static_text(self, "Session logs", "BS_Network_SessionLogs")

menu.add_combo(self, "Script events", "BS_Network_SessionLogs_ScriptEvents", {"None", "File", "Console", "File & Console"}, function (_, pos)
    local listName = "BS_Network_SessionLogs_ScriptEvents"
    if pos > 1 then
        if not listener.exists(listName, GET_EVENTS_LIST().OnScriptEvent) then
            listener.register(listName, GET_EVENTS_LIST().OnScriptEvent, function (pid, eventHash, eventArgs)
                local pos = GET_OPTIONS().combo['BS_Network_SessionLogs_ScriptEvents']:get()
                local logInfo = string.format("Sender: %s | Event hash: %s | Event args: %s", player.get_name(pid), eventHash, table.concat(eventArgs, ", "))
                if pos == 1 or pos == 3 then
                    filesys.logInFile(paths.logs.scriptEvents, "Script event", logInfo)
                end
                if pos == 2 or pos == 3 then
                    log.default("Session logs", "[Script event] ".. logInfo .. '\n')
                end
            end)
        end
    elseif listener.exists(listName, GET_EVENTS_LIST().OnScriptEvent) then
        listener.remove(listName, GET_EVENTS_LIST().OnScriptEvent)
    end
end)

menu.add_combo(self, "Network events", "BS_Network_SessionLogs_NetEvents", {"None", "File", "Console", "File & Console"}, function (_, pos)
    local listName = "BS_Network_SessionLogs_NetEvents"
    if pos > 1 then
        if not listener.exists(listName, GET_EVENTS_LIST().OnNetworkEvent) then
            listener.register(listName, GET_EVENTS_LIST().OnNetworkEvent, function (pid, eventInfo)
                local ignore = {
                    ["REMOTE_SCRIPT_INFO_EVENT"] = true,
                    ["NETWORK_CHECK_EXE_SIZE_EVENT"] = true,
                    ["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] = true,
                    ["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] = true,
                    ["REMOTE_SCRIPT_LEAVE_EVENT"] = true,
                    ["GIVE_CONTROL_EVENT"] = true,
                    ["NETWORK_TRAIN_REPORT_EVENT"] = true,
                    ["SCRIPTED_GAME_EVENT"] = true,
                    ["NETWORK_ENTITY_AREA_STATUS_EVENT"] = true,
                    ["CLEAR_AREA_EVENT"] = true,
                    ["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] = true,
                    ["PLAYER_CARD_STAT_EVENT"] = true,
                }
                if ignore[net.get_name(eventInfo)] then return end
                local pos = GET_OPTIONS().combo['BS_Network_SessionLogs_NetEvents']:get()
                local logInfo = string.format("Sender: %s | Event name: %s | Event hash: %s", player.get_name(pid), net.get_name(eventInfo), net.get_hash(eventInfo))
                if pos == 1 or pos == 3 then
                    filesys.logInFile(paths.logs.netEvents, "Network event", logInfo)
                end
                if pos == 2 or pos == 3 then
                    log.default("Session logs", "[Network event] ".. logInfo .. '\n')
                end
            end)
        end
    elseif listener.exists(listName, GET_EVENTS_LIST().OnNetworkEvent) then
        listener.remove(listName, GET_EVENTS_LIST().OnNetworkEvent)
    end
end)

Stuff.isAlreadyDead = {}

menu.add_combo(self, "Kills", "BS_Network_SessionLogs_Kills", {"None", "File", "Console", "File & Console"}, function (_, pos)
    local taskName = "BS_Network_SessionLogs_Kills"
    if pos > 1 then
        if not task.exists(taskName) then
            task.createTask(taskName, 0.0, nil, function ()
                local function getCauseOfDeath(ped)
                    local cause = PED.GET_PED_CAUSE_OF_DEATH(ped)
                    for name, hash in pairs(ParsedFiles["weaponHashes"]) do
                        if hash == cause then
                            return name
                        end
                    end
                    if ENTITY.IS_ENTITY_A_VEHICLE(cause) then 
                        if HUD._GET_LABEL_TEXT(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(cause)) ~= "NULL" then
                            return HUD._GET_LABEL_TEXT(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(cause))
                        end
                    end
                    return "World collision"
                end
                for pid = 0, 32 do
                    if player.is_connected(pid) then
                        if not player.is_alive(pid) and Stuff.isAlreadyDead[pid] == nil then
                            local logInfo = ""
                            local killedPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local sourceOfDeath = PED.GET_PED_SOURCE_OF_DEATH(killedPed)
                            local killerPid = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(sourceOfDeath)
                            if killerPid ~= -1 then
                                logInfo = string.format("%s killed %s with %s", player.get_name(killerPid), player.get_name(pid), getCauseOfDeath(killedPed))
                            else
                                logInfo = string.format("%s died", player.get_name(pid))
                            end
                            local pos = GET_OPTIONS().combo['BS_Network_SessionLogs_Kills']:get()
                            if pos == 1 or pos == 3 then
                                filesys.logInFile(paths.logs.weapons, "Kill", logInfo)
                            end
                            if pos == 2 or pos == 3 then
                                log.default("Session logs", "[Kill] " ..  logInfo .. '\n')
                            end
                            Stuff.isAlreadyDead[pid] = true
                        elseif player.is_alive(pid) and Stuff.isAlreadyDead[pid] then
                            Stuff.isAlreadyDead[pid] = nil
                        end
                    else
                        Stuff.isAlreadyDead[pid] = nil
                    end
                end
            end)
        end
    elseif task.exists(taskName) then
        task.removeTask(taskName)
    end
end)


menu.add_static_text(self, "Kosatka missiles", "BS_Network_Kosatka")

menu.add_looped_option(self, "Disable cooldown", "BS_Network_Kosatka_DisableCooldown", 0.0, function ()
    scripts.globals.setKosatkaMissileCooldown(0.0)
end)

menu.add_looped_option(self, "Disable range restrictions", "BS_Network_Kosatka_DisableRangeLimit", 0.0, function ()
    scripts.globals.setKosatkaMissileRange(150000.0)
end)

menu.add_static_text(self, "Misc", "BS_Network_Misc")

Stuff.activePlayerBlips = {}

menu.add_checkbox(self, "Show off the radar players", "BS_Network_Misc_ShowOTRPlayers", function (_, state)
    local taskName = "BS_Network_Misc_ShowOTRPlayers"
    if state then
       if not task.exists(taskName) then
            task.createTask(taskName, 0.0, nil, function ()
                for pid = 0, 32 do
                    if player.is_connected(pid) then
                        if scripts.globals.getPlayerOtr(pid) == 1 and Stuff.activePlayerBlips[pid] == nil then
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local blip = HUD.ADD_BLIP_FOR_ENTITY(ped)
                            HUD.SET_BLIP_SPRITE(blip, 1)
                            HUD.SET_BLIP_COLOUR(blip, 55)
                            HUD.SHOW_HEIGHT_ON_BLIP(blip, false)
                            HUD.SET_BLIP_ROTATION(blip, math.ceil(ENTITY.GET_ENTITY_HEADING(ped)))
                            NETWORK.SET_NETWORK_ID_CAN_MIGRATE(ped, false)
                            Stuff.activePlayerBlips[pid] = blip
                            notify.default("Network", "Player " .. player.get_name(pid) .. " is Off the radar.\nYou still can see him on the map (grey blip).", GET_NOTIFY_ICONS().players)
                        elseif scripts.globals.getPlayerOtr(pid) == 0 and Stuff.activePlayerBlips[pid] then
                            HUD.SET_BLIP_DISPLAY(Stuff.activePlayerBlips[pid], 0)
                            Stuff.activePlayerBlips[pid] = nil
                        end
                    end
                end
            end)
       end
    elseif task.exists(taskName) then
        task.removeTask(taskName)
    end
end)

-- END