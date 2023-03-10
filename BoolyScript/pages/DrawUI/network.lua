Network = Submenu.add_static_submenu("Network", "BS_Network")
Main:add_sub_option("Network", "BS_Network", Network)

local sessionTypes = {
    "Public",
    "New Public",
    "Closed Crew",
    "Open Crew",
    "Friends Only",
    "Join Friends",
    "Solo",
    "Invite Only"
}

Network:add_choose_option("Join session", "BS_Network_JoinSession", false, sessionTypes, function (pos, option)
    if pos <= 4 then
        lobby.change_session(pos - 1)
    elseif pos == 5 then lobby.change_session(pos + 1)
    elseif pos >= 6 then lobby.change_session(pos + 3)
    end
end)

local vehicleBlacklist = Submenu.add_static_submenu("Vehicle blacklist", "BS_Network_VehicleBlacklist") do
    local addedVehicles = {}
    local search = Submenu.add_static_submenu("Search", "BS_Network_VehicleBlacklist_Search") do
        local options = {}
        local name = search:add_text_input("Name/Hash", "BS_Network_VehicleBlacklist_Search_Name"):setConfigIgnore()
        search:add_click_option("Find", "BS_Network_VehicleBlacklist_Search_Find", function ()
            if name:getValue() == "" then return notify.warning("Vehicle blacklist", "Enter vehicle name/hash before.") end
            notify.important("Vehicle blacklist", "Searching for the results...")
            local request = tostring(name:getValue())
            for _, option in ipairs(options) do
                option:remove()
            end
            options = {}
            for name, hash in pairs(ParsedFiles.vehicles) do
                local label = HUD._GET_LABEL_TEXT(name)
                label = label ~= "NULL" and label or name
                if string.find(string.lower(name), string.lower(request)) or hash == tonumber(request) then
                    table.insert(options, search:add_click_option(label, "BS_Network_VehicleBlacklist_SearchResults_" .. name, function ()
                        local content = parse.json(paths.files.vehicleBlacklist) or {}
                        if not content[name] then
                            content[name] = hash
                            local file = io.open(paths.files.vehicleBlacklist, "w+")
                            file:write(json:encode_pretty(content))
                            file:close()
                            table.insert(addedVehicles, vehicleBlacklist:add_bool_option(label, "BS_Network_VehicleBlacklist_" .. name, function (state)
                                if state then
                                    table.insert(Stuff.blacklistedVehicles, hash)
                                else
                                    for ID, hash_n in ipairs(Stuff.blacklistedVehicles) do
                                        if hash_n == hash then
                                            table.remove(Stuff.blacklistedVehicles, ID)
                                            break
                                        end
                                    end
                                end
                            end):setTranslationIgnore():setHint("Toggles blocking for that vehicle."):setDeletable(function ()
                                local content = parse.json(paths.files.vehicleBlacklist) or {}
                                if content[name] then
                                    content[name] = nil
                                    local file = io.open(paths.files.vehicleBlacklist, "w+")
                                    file:write(json:encode_pretty(content))
                                    file:close()
                                    notify.success("Vehicle blacklist", string.format("\'%s\' has been successfully removed from the blacklist.", label))
                                end
                            end))
                            notify.success("Vehicle blacklist", string.format("\'%s\' has been successfully added in the blacklist.", label))
                        else
                            notify.fatal("Vehicle blacklist", "That vehicle already exists in your blacklist.")
                        end
                    end):setTranslationIgnore():setHint("Click to add it in blacklist."))
                end
            end
            if #options > 0 then
                notify.success("Vehicle blacklist", string.format("Found %i results.", #options))
            else
                notify.fatal("Vehicle blacklist", "Unfortunately, nothing was found..")
            end
        end)
        search:add_separator("Results", "BS_Network_VehicleBlacklist_Search_Results")
        vehicleBlacklist:add_sub_option("Search", "BS_Network_VehicleBlacklist_Search", search)
    end
    local playersReactions = {}
    vehicleBlacklist:add_looped_option("Enable blacklist", "BS_Network_VehicleBlacklist_Enable", 2.0, function ()
        for pid = 0, 32 do
            if player.is_connected(pid) and pid ~= player.index() then
                local vehicle = player.get_vehicle_handle(pid)
                local hash = ENTITY.GET_ENTITY_MODEL(vehicle)
                for _, vehicleHash in ipairs(Stuff.blacklistedVehicles) do
                    if vehicleHash == hash then
                        log.default("Vehicle blacklist", string.format("Player %s is using a blacklisted vehicle. Applying reaction...", player.get_name(pid)))
                        Stuff.onBlacklistedVehicle(pid)
                        break
                    end
                end
            end
        end
    end)
    vehicleBlacklist:add_choose_option("Reaction", "BS_Network_VehicleBlacklist_Reaction", true, {"Destroy vehicle", "Kick from vehicle", "Kick from server", "Crash"}, function (pos)
        if pos == 1 then
            Stuff.onBlacklistedVehicle = player.vehicle_destroy
        elseif pos == 2 then
            Stuff.onBlacklistedVehicle = player.vehicle_kick
        elseif pos == 3 then
            Stuff.onBlacklistedVehicle = player.kick_idm
        elseif pos == 4 then
            Stuff.onBlacklistedVehicle = scripts.events.crash
        end
    end):setValue(1)
    vehicleBlacklist:add_separator("Blacklisted", "BS_Network_VehicleBlacklist_Search_Blacklisted")
    parse.json(paths.files.vehicleBlacklist, function (content)
        for _, option in ipairs(addedVehicles) do
            option:remove()
        end
        addedVehicles = {}
        for name, hash in pairs(content) do
            local label = HUD._GET_LABEL_TEXT(name)
            label = label ~= "NULL" and label or name
            table.insert(addedVehicles, vehicleBlacklist:add_bool_option(label, "BS_Network_VehicleBlacklist_" .. name, function (state)
                if state then
                    table.insert(Stuff.blacklistedVehicles, hash)
                else
                    for ID, hash_n in ipairs(Stuff.blacklistedVehicles) do
                        if hash_n == hash then
                            table.remove(Stuff.blacklistedVehicles, ID)
                            break
                        end
                    end
                end
            end):setTranslationIgnore():setHint("Toggles blocking for that vehicle."):setDeletable(function ()
                local content = parse.json(paths.files.vehicleBlacklist) or {}
                if content[name] then
                    content[name] = nil
                    local file = io.open(paths.files.vehicleBlacklist, "w+")
                    file:write(json:encode_pretty(content))
                    file:close()
                    notify.success("Vehicle blacklist", string.format("\'%s\' has been successfully removed from the blacklist.", label))
                end
            end))
        end
    end)
    Network:add_sub_option("Vehicle blacklist", "BS_Network_VehicleBlacklist", vehicleBlacklist):setHint("Prevents players to use vehicles you've\nblacklisted.")
end

local playerHistory = Submenu.add_static_submenu("Player history", "BS_Network_PlayerHistory") do
    local addedPlayers = {}
    local historySize = 90
    local addedOptions = {}
    local selectedPlayer = nil
    local playerInteractions = Submenu.add_static_submenu("Interactions", "BS_Network_PlayerHistory_PlayerInteractions") do
        playerInteractions:add_state_bar("Name:", "BS_Network_PlayerHistory_PlayerInteractions_Name", function ()
            if not selectedPlayer then return "None" end
            return selectedPlayer.name
        end)
        playerInteractions:add_state_bar("RID:", "BS_Network_PlayerHistory_PlayerInteractions_RID", function ()
            if not selectedPlayer then return "None" end
            return selectedPlayer.rid
        end)
        playerInteractions:add_state_bar("Last seen:", "BS_Network_PlayerHistory_PlayerInteractions_LastSeen", function ()
            if not selectedPlayer then return "None" end
            return selectedPlayer.last_seen
        end)
        playerInteractions:add_click_option("Check for online", "BS_Network_PlayerHistory_PlayerInteractions_CheckOnline", function ()
            social.is_player_online(selectedPlayer.rid, function (rid, result)
                if result then
                    notify.success("Player history", string.format("Player %s is online.", selectedPlayer.name))
                else
                    notify.fatal("Player history", string.format("Player %s is offline.", selectedPlayer.name))
                end
            end)
        end)
        playerInteractions:add_choose_option("Join", "BS_Network_PlayerHistory_PlayerInteractions_Join", false, {"Default method", "Friend method"}, function (pos)
            lobby.join_by_rid(selectedPlayer.rid, pos == 2)
        end)
    end
    local loadPlayers = function ()
        parse.json(paths.files.playerHistory, function (content)
            addedPlayers = content
            for _, option in ipairs(addedOptions) do
                option:remove()
            end
            addedOptions = {}
            for _, player in ipairs(content) do
                table.insert(addedOptions, playerHistory:add_sub_option(player.name, "", playerInteractions, function ()
                    selectedPlayer = player
                end):setConfigIgnore():setTranslationIgnore())
            end
        end)
    end
    local addPlayer = function (rid, name)
        local player = 
        {
            name = name,
            rid = rid,
            last_seen = os.date("%x at %X")
        }
        
        local playerExists = false
        for index, data in ipairs(addedPlayers) do
            if data.rid == rid then
                data = player
                playerExists = true
                break
            end
        end

        if not playerExists then
            table.insert(addedPlayers, 1, player)
        end

        local out = addedPlayers
        if #addedPlayers > historySize then 
            out = {}
            for i = 1, historySize do
                table.insert(out, addedPlayers[i])
            end
        end

        local file = io.open(paths.files.playerHistory, "w+")
        file:write(json:encode_pretty(out))
        file:close()
        loadPlayers()
    end
    
    playerHistory:add_bool_option("Enable", "BS_Network_PlayerHistory_Enable", function (state)
        if state then
            listener.register("BS_Network_PlayerHistory", GET_EVENTS_LIST().OnPlayerActive, function (pid)
                if player.is_local(pid) then return end
                addPlayer(player.get_rid(pid), player.get_name(pid))
            end)
        elseif listener.exists("BS_Network_PlayerHistory", GET_EVENTS_LIST().OnPlayerActive) then
            listener.remove("BS_Network_PlayerHistory", GET_EVENTS_LIST().OnPlayerActive)
        end
    end)
    local settings = Submenu.add_static_submenu("Settings", "BS_Network_PlayerHistory_Settings") do
        settings:add_num_option("Max size", "BS_Network_PlayerHistory_Size", 10, 1500, 10, function (val)
            historySize = val
        end):setValue(90, true)
        settings:add_separator("Danger Zone", "BS_Network_PlayerHistory_DangerZone")
        settings:add_click_option("Clear", "BS_World_PlayerHistory_Clear", function ()
            local file = io.open(paths.files.playerHistory, "w")
            file:write("")
            file:close()
            for _, option in ipairs(addedOptions) do
                option:remove()
            end
            addedOptions = {}
            notify.success("Player history", "Successfully cleared the player history.")
        end)
        playerHistory:add_sub_option("Settings", "BS_Network_PlayerHistory_Settings", settings)
    end
    local search = Submenu.add_static_submenu("Search", "BS_Network_PlayerHistory_Search") do
        local options = {}
        local name = search:add_text_input("Name/RID", "BS_World_PlayerHistory_Search_Name"):setConfigIgnore()
        search:add_click_option("Find", "BS_World_PlayerHistory_Search_Find", function ()
            if name:getValue() == "" then return notify.warning("Player history", "Enter player's RID or name first.") end
            notify.important("Player history", "Searching for the results...")
            local request = tostring(name:getValue())
            for _, option in ipairs(options) do
                option:remove()
            end
            options = {}
            for _, t in ipairs(addedPlayers) do
                if string.find(string.lower(t.name), string.lower(request)) or t.rid == tonumber(request) then
                    table.insert(options, search:add_sub_option(t.name, "", playerInteractions, function ()
                        selectedPlayer = t
                    end):setConfigIgnore():setTranslationIgnore())
                end
            end
            if #options > 0 then
                notify.success("Player history", string.format("Found %i results.", #options))
            else
                notify.fatal("Player history", "Unfortunately, nothing was found..")
            end
        end)
        search:add_separator("Results", "BS_Network_PlayerHistory_Results")
        playerHistory:add_sub_option("Search", "BS_Network_PlayerHistory_Search", search)
    end
    playerHistory:add_separator("History", "BS_Network_PlayerHistory_Players")
    loadPlayers()
    Network:add_sub_option("Player history", "BS_Network_PlayerHistory", playerHistory)
end

-- local playerManager = Submenu.add_static_submenu("Player manager", "BS_Network_PlayerManager") do
--     local Player = function (rid, name, note, checkOnline, notify, autoJoin, notifyOnJoin, kickOnJoin, syncOnJoin)        
--         return {
--             name = name,
--             rid = rid,
--             note = note,
--             last_seen = os.date("%x at %X"),
--             check_online = checkOnline,
--             notify = notify,
--             auto_join = autoJoin,
--             on_join = {
--                 notify = notifyOnJoin,
--                 kick = kickOnJoin,
--                 block_sync = syncOnJoin,
--             }
--         }
--     end

--     local addedOptions = {}
--     local selectedPlayer = nil

--     local Folder = {
--         registered = {},
--         name = nil,
--         submenu = nil,
--     }
--     Folder.__index = Folder

--     function Folder.exists(name)
--         for _, t in ipairs(Folder.registered) do
--             if t.name == name then return true end
--         end
--         return false
--     end

--     function Folder.new(name)
--         if Folder.exists(name) then
--             return notify.fatal("Player manager", string.format("'%s' folder already exists.", name))
--         end
--         local out = setmetatable({}, Folder)
--         out.name = name
--         out.submenu = Submenu.add_static_submenu(name, "")
--         playerManager:add_sub_option(name, "", out.submenu):setTranslationIgnore()
--         table.insert(Folder.registered, out)
--         return out
--     end

--     function Folder.savePlayers()
--         local out = {}
--         for _, folder in ipairs(Folder.registered) do
--             local players = {}
--             for _, option in ipairs(folder.submenu.options) do
--                 table.insert(players, option:getValue())
--             end
--             table.insert(out, {name = folder.name, registered = players})
--         end
--         local file = io.open(paths.files.playerManager, "w+")
--         file:write(json:encode_pretty(out))
--         file:close()
--     end

--     function Folder:playerExists(player_t)
--         for index, option in ipairs(self.submenu.options) do
--             if option:getValue().rid == player_t.rid then
--                 return index
--             end
--         end
--         return false
--     end

--     function Folder:addPlayer(player_t)
--         if self:playerExists(player_t) then return notify.fatal("Player manager", string.format("'%s' player already exists.", player_t.name)) end
--         local playerInteractions = Submenu.add_static_submenu(player_t.name, "") do
--             playerInteractions:add_state_bar("Name:", "BS_Network_PlayerHistory_PlayerInteractions_Name", function ()
--                 if not selectedPlayer then return "None" end
--                 return selectedPlayer.name
--             end)
--             playerInteractions:add_state_bar("RID:", "BS_Network_PlayerHistory_PlayerInteractions_RID", function ()
--                 if not selectedPlayer then return "None" end
--                 return selectedPlayer.rid
--             end)
--             playerInteractions:add_state_bar("Last seen:", "BS_Network_PlayerHistory_PlayerInteractions_LastSeen", function ()
--                 if not selectedPlayer then return "None" end
--                 return selectedPlayer.last_seen
--             end)
--             playerInteractions:add_click_option("Check for online", "BS_Network_PlayerHistory_PlayerInteractions_CheckOnline", function ()
--                 social.is_player_online(selectedPlayer.rid, function (rid, result)
--                     if result then
--                         notify.success("Player manager", string.format("Player %s is online.", selectedPlayer.name))
--                     else
--                         notify.fatal("Player manager", string.format("Player %s is offline.", selectedPlayer.name))
--                     end
--                 end)
--             end)
--             playerInteractions:add_choose_option("Join", "BS_Network_PlayerHistory_PlayerInteractions_Join", false, {"Default method", "Friend method"}, function (pos)
--                 lobby.join_by_rid(selectedPlayer.rid, pos == 2)
--             end)
--             local option = self.submenu:add_sub_option(player_t.name, "", playerInteractions, function ()
--                 selectedPlayer = player_t
--             end):setTranslationIgnore():setValue(player_t)
--             table.insert(Stuff.trackedPlayers, {meta = player_t, option = option})
--         end
--         return self
--     end

--     function Folder:removePlayer(player_t)
--         if not self:playerExists(player_t) then return notify.fatal("Player manager", string.format("'%s' player doesn't exist.", player_t.name)) end
--         local out = {}
--         for _, option in ipairs(self.submenu) do
--             if option:getValue() ~= player_t then
--                 table.insert(out, option)
--             else
--                 option:remove()
--             end
--         end
--         self.submenu = out
--         for index, player in ipairs(Stuff.trackedPlayers) do
--             if player.meta.rid == player_t.rid then
--                 table.remove(Stuff.trackedPlayers, index)
--                 break
--             end
--         end
--         return self
--     end

--     function Folder:getSubmenu()
--         return self.submenu
--     end

--     local loadPlayers = function ()
--         parse.json(paths.files.playerManager, function (content)
--             for _, folder in ipairs(content) do
--                 local handle = Folder.new(folder.name)
--                 for _, player in ipairs(folder.registered) do
--                     handle:addPlayer(player)
--                 end
--             end
--         end)
--     end
    
--     local newPlayer = Submenu.add_static_submenu("Add player", "BS_Network_PlayerManager_AddPlayer") do
--         local folders = {}
--         local selectedFolder = nil
--         local function getFolders()
--             local out = {}
--             for _, folder in ipairs(Folder.registered) do
--                 table.insert(out, folder.name)
--             end
--             return out
--         end
--         local function updateFolders()
--             folders:setTable(getFolders()):setValue(1)
--         end
--         folders = newPlayer:add_choose_option("Folder", "BS_Network_PlayerManager_AddPlayer_Folder", true, {"None"}, function (pos, option)
--             local name = option:getTable()[pos]
--             for _, folder in ipairs(Folder.registered) do
--                 if folder.name == name then
--                     selectedFolder = folder
--                     break
--                 end
--             end
--         end):setHint("Select an existing folder.")
--         local name = newPlayer:add_text_input("New folder", "BS_Network_PlayerManager_AddPlayer_FolderName")
--         newPlayer:add_click_option("Create & save new folder", "BS_Network_PlayerManager_AddPlayer_FolderCreate", function ()
--             local name = name:getValue()
--             name = name ~= "" and name or "Untitled"
--             if Folder.exists(name) then
--                 return notify.fatal("Player manager", string.format("'%s' folder already exists.", name))
--             end
--             Folder.new(name)
--             updateFolders()
--             Folder.savePlayers()
--             notify.success("Player manager", "Successfully created '" .. name .. "' folder.")
--         end)
--         task.executeAsScript("PlayerManager_LoadFolders", function ()
--             updateFolders()
--         end)
--         newPlayer:add_separator("Player info", "BS_Network_PlayerManager_AddPlayer_PlayerInfo")
--         local playerName = newPlayer:add_text_input("Name", "BS_Network_PlayerManager_AddPlayer_PlayerInfo_Name")
--         local playerRid = newPlayer:add_text_input("RID", "BS_Network_PlayerManager_AddPlayer_PlayerInfo_Rid")
--         local playerNote = newPlayer:add_text_input("Note", "BS_Network_PlayerManager_AddPlayer_PlayerInfo_Note")
--         newPlayer:add_separator("Parameters", "BS_Network_PlayerManager_AddPlayer_Parameters")
--         local playerNotify = newPlayer:add_bool_option("Notify", "BS_Network_PlayerManager_AddPlayer_Parameters_Notify"):setHint("Notify when player comes online.")
--         local playerAutoJoin = newPlayer:add_bool_option("Auto-join", "BS_Network_PlayerManager_AddPlayer_Parameters_AutoJoin"):setHint("Tries to join player when he comes online.")
--         local playerCheckOnline = newPlayer:add_bool_option("Check online", "BS_Network_PlayerManager_AddPlayer_Parameters_ChechOnline"):setHint("Updates player status (Online/Offline).")
--         newPlayer:add_separator("Reactions on join", "BS_Network_PlayerManager_AddPlayer_Reactions")
--         local playerNotifyOnJoin = newPlayer:add_bool_option("Notify", "BS_Network_PlayerManager_AddPlayer_Reactions_Notify")
--         local playerKickOnJoin = newPlayer:add_bool_option("Kick (IDM)", "BS_Network_PlayerManager_AddPlayer_Reactions_Kick")
--         local playerBlockOnJoin = newPlayer:add_bool_option("Block sync", "BS_Network_PlayerManager_AddPlayer_Reactions_BlockSync")
--         newPlayer:add_separator("Manager", "BS_Network_PlayerManager_AddPlayer_Manager")
--         newPlayer:add_click_option("Save", "BS_Network_PlayerManager_AddPlayer_Save", function ()
--             if playerRid:getValue() == "" or playerName:getValue() == "" then return notify.fatal("Player manager", "Enter player name and RID first.") end
--             local player = Player(
--                 tonumber(playerRid:getValue()),
--                 playerName:getValue(), 
--                 playerNote:getValue(), 
--                 playerCheckOnline:getValue(), 
--                 playerNotify:getValue(), 
--                 playerAutoJoin:getValue(), 
--                 playerNotifyOnJoin:getValue(), 
--                 playerKickOnJoin:getValue(), 
--                 playerBlockOnJoin:getValue()
--             )
--             if not selectedFolder then return notify.fatal("Player manager", "Select or create a folder first.") end
--             if selectedFolder:playerExists(player) then return notify.fatal("Player manager", "Player already exists.") end
--             selectedFolder:addPlayer(player)
--             Folder.savePlayers()
--             notify.success("Player manager", string.format("Player '%s' has been successfully added in PM.", player.name))
--         end)
--         playerManager:add_sub_option("Add player", "BS_Network_PlayerManager_AddPlayer", newPlayer)
--     end

--     playerManager:add_bool_option("Enable", "BS_Network_PlayerManager_Enable", function (state)
--         local checkerPos = 0
--         task.createTask("PlayerManager_Tracking_2", 2.0, nil, function ()       
--             checkerPos = #Stuff.trackedPlayers < checkerPos and checkerPos + 1 or 1
--             local rid = Stuff.trackedPlayers[checkerPos].meta.rid or 0
--             social.is_player_online(rid, function (rid, status)
--                 if status then
--                     Stuff.trackedPlayers[checkerPos].option:setTags({{"[Online]", 0, 255, 0}})
--                 else
--                     Stuff.trackedPlayers[checkerPos].option:setTags({{"[Offline]", 255, 0, 0}})
--                 end
--             end)
--         end)
--     end)

--     -- local mainFolder = Folder.new("Main")
--     -- task.executeAsScript("PlayerManager_Load", function ()        
--     --     PlayerInteractions:add_click_option("Add", "", function ()
--     --         mainFolder:addPlayer(Player(player.get_rid(GetSelectedPlayer()), "OxiGen", true, false, true, false, true, false))
--     --     end)
--     -- end)
--     -- local search = Submenu.add_static_submenu("Search", "BS_Network_PlayerHistory_Search") do
--     --     local options = {}
--     --     local name = search:add_text_input("Name/RID", "BS_World_PlayerHistory_Search_Name"):setConfigIgnore()
--     --     search:add_click_option("Find", "BS_World_PlayerHistory_Search_Find", function ()
--     --         if name:getValue() == "" then return notify.warning("Player history", "Enter player's RID or name first.") end
--     --         notify.important("Player history", "Searching for the results...")
--     --         local request = tostring(name:getValue())
--     --         for _, option in ipairs(options) do
--     --             option:remove()
--     --         end
--     --         options = {}
--     --         for _, t in ipairs(addedPlayers) do
--     --             if string.find(string.lower(t.name), string.lower(request)) or t.rid == tonumber(request) then
--     --                 table.insert(options, search:add_sub_option(t.name, "", playerInteractions, function ()
--     --                     selectedPlayer = t
--     --                 end):setConfigIgnore():setTranslationIgnore())
--     --             end
--     --         end
--     --         if #options > 0 then
--     --             notify.success("Player history", string.format("Found %i results.", #options))
--     --         else
--     --             notify.fatal("Player history", "Unfortunately, nothing was found..")
--     --         end
--     --     end)
--     --     search:add_separator("Results", "BS_Network_PlayerHistory_Results")
--     --     playerManager:add_sub_option("Search", "BS_Network_PlayerHistory_Search", search)
--     -- end
--     playerManager:add_separator("Folders", "BS_Network_PlayerManager_Folders")
--     loadPlayers()
--     Network:add_sub_option("Player manager", "BS_Network_PlayerManager", playerManager)
-- end

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