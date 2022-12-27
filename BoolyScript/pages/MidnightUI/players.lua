require("Git/BoolyScript/util/menu")
local gui = require("Git/BoolyScript/globals/gui")
require("Git/BoolyScript/system/events_listener")
require("Git/BoolyScript/util/notify_system")
local scripts = require("Git/BoolyScript/rage/scripts")
--local json = require("Git/BoolyScript/modules/JSON")
require("Git/BoolyScript/rage/players_mgr")

local page = GET_PAGES()['BS_Main']
local self = menu.add_mono_block(page, "Players", "BS_Players", BLOCK_ALIGN_RIGHT)

local playerList = menu.add_combo_ex(self, "Player list", "BS_Players_PLayerList", function (_, index)
    local player_m = connectedPlayers[index]
    return string.format("%i. %s", player_m.pid, player_m.name)
end, function ()
    return #connectedPlayers
end)

function getSelectedPlayer()
    local comboVal = playerList:get_long()
    local player_m = connectedPlayers[comboVal]
    if player_m == nil then return -1 end
    return player_m
end

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

menu.add_dynamic_text(self, "BS_Players_Info", function ()
    local player_m = getSelectedPlayer()
    return string.format("Player info\nName: %s\nRID: %i\nIP: %s\nGeoIP: %s", player_m.name, player_m.rid, player_m.ip, player_m.GeoIP)
end)

menu.add_button(self, "Copy info", "BS_Players_Info_CopyInfo", function ()
    local player_m = getSelectedPlayer()
    if not player.is_connected(player_m.pid) then return end
    local out = string.format("Player info\nName: %s\nRID: %i\nIP: %s\nGeoIP: %s", player_m.name, player_m.rid, player_m.ip, player_m.GeoIP)
    utils.set_clipboard(out)
    notify.success("Players", "Copied player info into your clipboard.", gui.icons.players)
end)

menu.add_static_text(self, "Removals", "BS_Players_Removals")

menu.add_button(self, "IDM kick", "BS_Players_Removals_Kick", function ()
    local player_m = getSelectedPlayer()
    if not player.is_connected(player_m.pid) then return end
    player.kick_idm(player_m.pid)
end)

menu.add_button(self, "SE crash", "BS_Players_Removals_Crash", function ()
    local player_m = getSelectedPlayer()
    if not player.is_connected(player_m.pid) then return end
    scripts.events.crash(player_m.pid)
end)

menu.add_static_text(self, "Neutral", "BS_Players_Neutral")

menu.add_button(self, "Copy outfit", "BS_Players_Neutral_CopyOutfit", function ()
    local player_m = getSelectedPlayer()
    if not player.is_connected(player_m.pid) then return end
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_m.pid)
    for i = 0, 11 do
		PED.SET_PED_COMPONENT_VARIATION(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_DRAWABLE_VARIATION(ped, i), PED.GET_PED_TEXTURE_VARIATION(ped, i), PED.GET_PED_PALETTE_VARIATION(ped, i))
	end
	for i = 0, 7 do
        if PED.GET_PED_PROP_INDEX(ped, i) >= 0 and PED.GET_PED_PROP_TEXTURE_INDEX(ped, i) >= 0 then
		    PED.SET_PED_PROP_INDEX(PLAYER.PLAYER_PED_ID(), i, PED.GET_PED_PROP_INDEX(ped, i), PED.GET_PED_PROP_TEXTURE_INDEX(ped, i), true)
        end
	end
end)

menu.add_button(self, "Teleport (Me -> Player)", "BS_Players_Neutral_TeleportMeToPlayer", function ()
    local player_m = getSelectedPlayer()
    if not player.is_connected(player_m.pid) then return end
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_m.pid)
    local playerCoords = ENTITY.GET_ENTITY_COORDS(ped, true)
    utils.teleport(playerCoords)
end)

-- END