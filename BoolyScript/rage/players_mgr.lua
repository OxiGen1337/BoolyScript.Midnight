require("BoolyScript/util/notify_system")
local json = require("BoolyScript/modules/JSON")
require("BoolyScript/system/tasks")
require("BoolyScript/system/events_listener")

Player = {}
Player.__index = Player

connectedPlayers = {}
playersGeoIP = {}

Player.new = function (pid)
    if not player.is_connected(pid) then return nil end
    local self = setmetatable({}, Player)
    self.name = player.get_name(pid)
    self.rid = player.get_rid(pid)
    self.ip = player.get_ip_string(pid)
    self.pid = pid
    self.GeoIP = playersGeoIP[pid]
    if not self.GeoIP then self.GeoIP = "None" end
    return self
end

Player.exists = function (self)
    return getmetatable(self) == Player
end

Player.free = function (self)
    if not self:exists() then return nil end
    for _, value in ipairs(connectedPlayers) do
        if value == self.pid then
            value = nil
        end
    end
    self = nil
    return true
end

Player.isConnected = function (self)
    return player.is_connected(self.pid), self
end

task.createTask("Rage_Players_mgr_PlayerList", 0.0, nil, function ()
    local t = {}
    for pid = 0, 32 do
        if player.is_connected(pid) then
            table.insert(t, Player.new(pid))
        end
    end
    connectedPlayers = t
end)

-- listener.register("Rage_Players_mgr_CheckGeoIP", GET_EVENTS_LIST().OnPlayerActive, function (pid)
--     system.fiber(function ()     
--         local ip = player.get_ip_string(pid)
--         http.get("http://ip-api.com/json/".. ip, function (code, _, rawContent)
--             log.dbg(string.format("Resolving GeoIP | PID: %i; Name: %s | IP: %s", pid, player.get_name(pid), ip))
--             if code == 200 then
--                 local content = json.decode(rawContent)
--                 playersGeoIP[pid] = string.format("%s, %s", content["countryCode"], content["city"])
--             else
--                 log.error("HTTP", string.format("Failed to get GeoIP | Error code: %i", code))
--             end
--         end)
--     end)
-- end)