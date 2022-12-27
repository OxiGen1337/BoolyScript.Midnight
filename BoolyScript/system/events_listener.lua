require("Git/BoolyScript/util/notify_system")

local onEventFunctions = {}

local events = {
    OnKeyPressed = 1,
    OnFrame = 2,
    OnFeatureTick = 3,
    OnInit = 4,
    OnDone = 5,
    OnPlayerJoin = 6,
    OnPlayerLeft = 7,
    OnPlayerJoinByRid = 8,
    OnScriptEvent = 9,
    OnChatMsg = 10,
    OnNetworkEvent = 11,
    OnTransitionEnd = 12, 
    OnFirstSingleplayerJoin = 13,
    OnSessionJoin = 14,
    OnVehicleEnter = 15,
    OnVehicleLeave = 16,
    OnModderDetected = 17,
    OnGameState = 18,
    OnPlayerActive = 19,
}

for name, _ in pairs(events) do
    onEventFunctions[name] = {}
end

GET_REGISTERED_LISTENERS = function ()
    return onEventFunctions
end

GET_EVENTS_LIST = function ()
    return events
end

listener = {}

listener.register = function (hash_s, eventID, callback_t)
    for name, index in pairs(events) do
        if eventID == index then
            if eventID == events.OnInit then
                table.insert(onEventFunctions.OnInit, {hash = hash_s, callback = callback_t})
            else
                onEventFunctions[name][hash_s] = callback_t
            end
            log.dbg(string.format("[EVENTS_LISTENER] Successfully registered listener with hash: %s", hash_s))
            return true
        end
    end
    log.error("EVENTS_LISTENER", string.format("Failed to register listener with hash: %s | Invalid event %i.", hash_s, eventID))
    return false
end

listener.remove = function (hash_s, eventID)
    for name, index in pairs(events) do
        if index == eventID then
            if eventID == events.OnInit then
                for _, t in ipairs(onEventFunctions.OnInit) do
                    if t["hash"] == hash_s then
                        t = nil
                        break
                    end
                    log.error("EVENTS_LISTENER", string.format("Failed to remove listener with hash: %s | Listener doesnt exist.", hash_s))
                    return false
                end
            else
                if not onEventFunctions[name][hash_s] then 
                    log.error("EVENTS_LISTENER", string.format("Failed to remove listener with hash: %s | Listener doesnt exist.", hash_s))
                    return false
                end
                onEventFunctions[name][hash_s] = nil
            end
            log.dbg(string.format("[EVENTS_LISTENER] Successfully removed listener with hash: %s", hash_s))
            return true
        end
    end
    log.error("EVENTS_LISTENER", string.format("Failed to remove listener with hash: %s | Invalid event %i.", hash_s, eventID))
    return false
end

listener.exists = function (hash_s, eventID)
    for name, index in pairs(events) do
        if index == eventID then
            if eventID == events.OnInit then
                for _, t in ipairs(onEventFunctions.OnInit) do
                    if t["hash"] == hash_s then
                        return true
                    end
                end
            else
                return not (onEventFunctions[name][hash_s] == nil)
            end
        end
    end
    return false
end

listener.setCallback = function (hash_s, eventID, callback_f)
    for name, index in pairs(events) do
        if index == eventID then
            if eventID == events.OnInit then
                for _, t in ipairs(onEventFunctions.OnInit) do
                    if t["hash"] == hash_s then
                        t['callback'] = callback_f
                        return true
                    end
                end
            else
               if onEventFunctions[name][hash_s] then
                    onEventFunctions[name][hash_s]['callback'] = callback_f
                    return true
               end
            end
        end
    end
    log.error("EVENTS_LISTENER", string.format("Failed to set listener callback with hash: %s | Listener doesnt exist.", hash_s))
    return false
end


function OnInit()
    local startTime = os.clock()
    log.init("             ******         **            **          **     **    **        ")
    log.init("            **   **     **     **     **     **      **       **  **         ")
    log.init("           **    **    **      **    **      **     **         ****          ")
    log.init("          ******      **       **   **       **    **           **           ")
    log.init("         **    **     **      **    **      **    **           **            ")
    log.init("        **    **      **    **      **    **     ********     **             ")
    log.init("       ******           **            **        ********     **              ")

    for _, t in ipairs(onEventFunctions.OnInit) do
        local hash_s, callback_f = t["hash"], t["callback"]
        --log.dbg("Exec: " .. hash_s)
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
    log.init(string.format("All modules were initialized in %f sec.", os.clock() - startTime))
    notify.success("BoolyScript", "Script has been loaded successfuly.\nAuthor: @OxiGen#1337.\nIf you find a bug or have a suggestion\nDM me in Discord.", GET_NOTIFY_ICONS().scripts)
end

function OnKeyPressed(key, isDown)
    for hash_s, callback_f in pairs(onEventFunctions.OnKeyPressed) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(key, isDown) 
        end
    end
end

function OnFrame()
    for hash_s, callback_f in pairs(onEventFunctions.OnFrame) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
end

function OnFeatureTick()
    for hash_s, callback_f in pairs(onEventFunctions.OnFeatureTick) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
end

function OnDone()
    for hash_s, callback_f in pairs(onEventFunctions.OnDone) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
end

function OnPlayerJoin(pid)
    for hash_s, callback_f in pairs(onEventFunctions.OnPlayerJoin) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(pid) 
        end
    end
end

function OnPlayerLeft(pid)
    for hash_s, callback_f in pairs(onEventFunctions.OnPlayerLeft) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(pid) 
        end
    end
end

function OnPlayerJoinByRid(rid)
    for hash_s, callback_f in pairs(onEventFunctions.OnPlayerJoinByRid) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(rid) 
        end
    end
end

function OnScriptEvent(pid, event, args)
    for hash_s, callback_f in pairs(onEventFunctions.OnScriptEvent) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            local out = callback_f(pid, event, args) 
            if out == false then return false end
        end
    end
end

function OnChatMsg(pid, text)
    for hash_s, callback_f in pairs(onEventFunctions.OnChatMsg) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(pid, text) 
        end
    end
end

function OnNetworkEvent(pid, event, buf)
    for hash_s, callback_f in pairs(onEventFunctions.OnNetworkEvent) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            local out = callback_f(pid, event, buf) 
            if out == false then return false end
        end
    end
end

function OnTransitionEnd(isMp)
    for hash_s, callback_f in pairs(onEventFunctions.OnTransitionEnd) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(isMp) 
        end
    end
end

function OnFirstSingleplayerJoin()
    for hash_s, callback_f in pairs(onEventFunctions.OnFirstSingleplayerJoin) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
end

function OnSessionJoin()
    for hash_s, callback_f in pairs(onEventFunctions.OnSessionJoin) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f() 
        end
    end
end

function OnVehicleEnter(handle)
    for hash_s, callback_f in pairs(onEventFunctions.OnVehicleEnter) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(handle) 
        end
    end
end

function OnVehicleLeave(handle)
    for hash_s, callback_f in pairs(onEventFunctions.OnVehicleLeave) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(handle) 
        end
    end
end

function OnModderDetected(pid, reason)
    for hash_s, callback_f in pairs(onEventFunctions.OnModderDetected) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(pid, reason) 
        end
    end
end

function OnGameState(old, new)
    for hash_s, callback_f in pairs(onEventFunctions.OnGameState) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(old, new) 
        end
    end
end

function OnPlayerActive(pid)
    for hash_s, callback_f in pairs(onEventFunctions.OnPlayerActive) do
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            callback_f = nil
        else 
            callback_f(pid) 
        end
    end
end