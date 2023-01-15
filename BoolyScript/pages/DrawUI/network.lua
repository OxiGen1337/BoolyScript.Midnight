Network = Submenu.add_static_submenu("Network", "BS_Network")
Main:add_sub_option("Network", "BS_Network", Network)

Network:add_separator("Kosatka missiles", "BS_Network_Kosatka")

Network:add_looped_option("Disable cooldown", "BS_Network_Kosatka_DisableCooldown", 0.0, function ()
    scripts.globals.setKosatkaMissileCooldown(0.0)
end)

Network:add_looped_option("Disable range restrictions", "BS_Network_Kosatka_DisableRangeLimit", 0.0, function ()
    scripts.globals.setKosatkaMissileRange(150000.0)
end)

Network:add_separator("Network chat", "BS_Network_Chat")
Network:add_bool_option("Chat mocker", "BS_Network_ChatMocker", function (state)
    if state then 
        listener.register("BS_Network_ChatMocker", GET_EVENTS_LIST().OnChatMsg, function (pid, text)
            if pid == player.index() then return end
            local finalText = ""
			for let in string.gmatch(text, '%D') do
				if math.random(0, 2) == 0 then let = string.upper(let) end
				finalText = finalText .. let
			end
			utils.send_chat(finalText, false)
        end)
    elseif listener.exists("BS_Network_ChatMocker", GET_EVENTS_LIST().OnChatMsg) then
        listener.remove("BS_Network_ChatMocker", GET_EVENTS_LIST().OnChatMsg)
    end
end):setHint(
[[
Example:
- I wanna money drop at airport!!!
- I wAnNA mOnEy drOp At AiRPort!!!
]]
)

Network:add_bool_option("Kick spammers", "BS_Network_KickSpammers", function (state)
    if state then 
        local messages = {}
        listener.register("BS_Network_KickSpammers", GET_EVENTS_LIST().OnChatMsg, function (pid, text)
            if pid == player.index() then return end
            local rid = player.get_rid(pid)
            if not messages[rid] then messages[rid] = {} end
            table.insert(messages[rid], text)
            local encMessages = {}
            local cnt = 0
            for _, message in ipairs(messages[rid]) do
                if encMessages[message] then
                    encMessages[message] = encMessages[message] + 1
                    cnt = math.max(cnt, encMessages[message])
                else
                    encMessages[message] = 1
                end
            end
            if cnt <= 3 then return end
            notify.warning("Network chat", string.format("Spammer detected | Name: %s\nKicking player...", player.get_name(pid)))
            messages[rid] = {}
            if player.is_session_host(player.index()) then -- Checks is the local player host
                player.kick(pid) -- HOST/VOTE kick
            else
                player.kick_idm(pid) -- UNBLOCKABLE IDM kick
            end
        end)
    elseif listener.exists("BS_Network_KickSpammers", GET_EVENTS_LIST().OnChatMsg) then
        listener.remove("BS_Network_KickSpammers", GET_EVENTS_LIST().OnChatMsg)
    end
end)

Network:add_separator("Misc", "BS_Network_Misc")

Stuff.activePlayerBlips = {}

Network:add_bool_option("Show off the radar players", "BS_Network_Misc_ShowOTRPlayers", function (state)
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
                    else
                        HUD.SET_BLIP_DISPLAY(Stuff.activePlayerBlips[pid], 0)
                        Stuff.activePlayerBlips[pid] = nil
                    end
                end
            end)
       end
    elseif task.exists(taskName) then
        task.removeTask(taskName)
    end
end)

Network:add_bool_option("Block sync to spectators", "BS_Network_Misc_BlockSyncToSpectators", function (state)
    if state then
        listener.register("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnSpectating, function (pid, target, _)
            if target ~= player.index() or pid == player.index() then return end
            if not player.is_connected(pid) then return end
            notify.important("Network", string.format("Player %s is spectating you. Blocking syncs to him.", player.get_name(pid)))
            player.ban(pid, -1, "Spectating")
        end)
        listener.register("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnStopSpectating, function (pid, target, _)
            if target ~= player.index() or pid == player.index() then return end
            if not player.is_connected(pid) then return end
            if not player.is_banned(pid) then return end
            notify.important("Network", string.format("Player %s is no more spectating.", player.get_name(pid)))
            player.unban(pid)
        end)
    else
        if listener.exists("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnSpectating) then
            listener.remove("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnSpectating)
        end
        if listener.exists("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnStopSpectating) then
            listener.remove("BS_Network_Misc_BlockSyncToSpectators", GET_EVENTS_LIST().OnStopSpectating)
        end
    end
end)

Network:add_separator("Session logs", "BS_Network_SessionLogs")

Network:add_choose_option("Script events", "BS_Network_SessionLogs_ScriptEvents", true, {"None", "File", "Console", "File & Console"}, function (pos, option)
    local listName = "BS_Network_SessionLogs_ScriptEvents"
    if pos > 1 then
        if not listener.exists(listName, GET_EVENTS_LIST().OnScriptEvent) then
            listener.register(listName, GET_EVENTS_LIST().OnScriptEvent, function (pid, eventHash, eventArgs)
                local pos = option:getValue()
                local logInfo = string.format("Sender: %s | Event hash: %s | Event args: %s", player.get_name(pid), eventHash, table.concat(eventArgs, ", "))
                if pos == 2 or pos == 4 then
                    filesys.logInFile(paths.logs.scriptEvents, "Script event", logInfo)
                end
                if pos == 3 or pos == 4 then
                    log.default("Session logs", "[Script event] ".. logInfo .. '\n')
                end
            end)
        end
    elseif listener.exists(listName, GET_EVENTS_LIST().OnScriptEvent) then
        listener.remove(listName, GET_EVENTS_LIST().OnScriptEvent)
    end
end)

Network:add_choose_option("Network events", "BS_Network_SessionLogs_NetEvents", true, {"None", "File", "Console", "File & Console"}, function (pos, option)
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
                local pos = option:getValue()
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

Network:add_choose_option("Kills", "BS_Network_SessionLogs_Kills", true, {"None", "File", "Console", "File & Console"}, function (pos, option)
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
                            local pos = option:getValue()
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


-- END