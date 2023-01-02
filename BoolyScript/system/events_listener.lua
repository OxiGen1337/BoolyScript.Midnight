require("BoolyScript/util/notify_system")

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

for _, ID in pairs(events) do
    onEventFunctions[ID] = {}
end

GET_REGISTERED_LISTENERS = function ()
    return onEventFunctions
end

GET_EVENTS_LIST = function ()
    return events
end

listener = {}

listener.register = function (hash_s, eventID, callback_t)
    table.insert(onEventFunctions[eventID], {hash = hash_s, callback = callback_t})
    log.dbg(string.format("[EVENTS_LISTENER] Successfully registered listener with hash: %s", hash_s))
    return true
end

listener.remove = function (hash_s, eventID)
    for ID, t in ipairs(onEventFunctions[eventID]) do
        if t["hash"] == hash_s then
            table.remove(onEventFunctions[eventID], ID)
            log.dbg("[EVENTS_LISTENER] " .. string.format("Successfully removed listener with hash: %s.", hash_s))
            return true
        end
    end
    log.error("EVENTS_LISTENER", string.format("Failed to remove listener with hash: %s | Listener doesnt exist.", hash_s))
    return false
end

listener.exists = function (hash_s, eventID)
    for ID, t in ipairs(onEventFunctions[eventID]) do
        if t["hash"] == hash_s then
            return true
        end
    end
    return false
end

listener.setCallback = function (hash_s, eventID, callback_f)
    for ID, t in ipairs(onEventFunctions[eventID]) do
        if t["hash"] == hash_s then
            t['callback'] = callback_f
            return true
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

    for ID, t in ipairs(onEventFunctions[events.OnInit]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        --log.dbg("Exec: " .. hash_s)
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnInit)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnInit) end
        end
    end
    log.init(string.format("All modules were initialized in %f sec.", os.clock() - startTime))
    notify.success("BoolyScript", "Script has been loaded successfuly.\nAuthor: @OxiGen#1337.\nIf you find a bug or have a suggestion\nDM me in Discord.", GET_NOTIFY_ICONS().scripts)
end

function OnKeyPressed(key, isDown)
    for ID, t in ipairs(onEventFunctions[events.OnKeyPressed]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnKeyPressed)
        else 
            local out = callback_f(key,isDown) 
            if out == false then listener.remove(hash_s, events.OnKeyPressed) end
        end
    end
end

function OnFrame()
    for ID, t in ipairs(onEventFunctions[events.OnFrame]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnFrame)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnFrame) end
        end
    end
end

function OnFeatureTick()
    for ID, t in ipairs(onEventFunctions[events.OnFeatureTick]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnFeatureTick)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnFeatureTick) end
        end
    end
end

function OnDone()
    for ID, t in ipairs(onEventFunctions[events.OnDone]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnDone)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnDone) end
        end
    end
end

function OnPlayerJoin(pid)
    for ID, t in ipairs(onEventFunctions[events.OnPlayerJoin]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnPlayerJoin)
        else 
            local out = callback_f(pid) 
            if out == false then listener.remove(hash_s, events.OnPlayerJoin) end
        end
    end
end

function OnPlayerLeft(pid)
    for ID, t in ipairs(onEventFunctions[events.OnPlayerLeft]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnPlayerLeft)
        else 
            local out = callback_f(pid) 
            if out == false then listener.remove(hash_s, events.OnPlayerLeft) end
        end
    end
end

function OnPlayerJoinByRid(rid)
    for ID, t in ipairs(onEventFunctions[events.OnPlayerJoinByRid]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnPlayerJoinByRid)
        else 
            local out = callback_f(rid) 
            if out == false then listener.remove(hash_s, events.OnPlayerJoinByRid) end
        end
    end
end

function OnScriptEvent(pid, event, args)
    for ID, t in ipairs(onEventFunctions[events.OnScriptEvent]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnScriptEvent)
        else 
            local out = callback_f(pid, event, args) 
            if out == false then listener.remove(hash_s, events.OnScriptEvent) end
        end
    end
end

function OnChatMsg(pid, text)
    for ID, t in ipairs(onEventFunctions[events.OnChatMsg]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnChatMsg)
        else 
            local out = callback_f(pid, text) 
            if out == false then listener.remove(hash_s, events.OnChatMsg) end
        end
    end
end

function OnNetworkEvent(pid, event, buf)
    for ID, t in ipairs(onEventFunctions[events.OnNetworkEvent]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnNetworkEvent)
        else 
            local out = callback_f(pid, event, buf) 
            if out == false then listener.remove(hash_s, events.OnNetworkEvent) end
        end
    end
end

function OnTransitionEnd(isMp)
    for ID, t in ipairs(onEventFunctions[events.OnTransitionEnd]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnTransitionEnd)
        else 
            local out = callback_f(isMp) 
            if out == false then listener.remove(hash_s, events.OnTransitionEnd) end
        end
    end
end

function OnFirstSingleplayerJoin()
    for ID, t in ipairs(onEventFunctions[events.OnFirstSingleplayerJoin]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnFirstSingleplayerJoin)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnFirstSingleplayerJoin) end
        end
    end
end

function OnSessionJoin()
    for ID, t in ipairs(onEventFunctions[events.OnSessionJoin]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnVehicleLeave)
        else 
            local out = callback_f() 
            if out == false then listener.remove(hash_s, events.OnVehicleLeave) end 
        end
    end
end

function OnVehicleEnter(handle)
    for ID, t in ipairs(onEventFunctions[events.OnVehicleEnter]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnVehicleLeave)
        else 
            local out = callback_f(handle) 
            if out == false then listener.remove(hash_s, events.OnVehicleLeave) end
        end
    end
end

function OnVehicleLeave(handle)
    for ID, t in ipairs(onEventFunctions[events.OnVehicleLeave]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnVehicleLeave)
        else 
            local out = callback_f(handle) 
            if out == false then listener.remove(hash_s, events.OnVehicleLeave) end
        end
    end
end

function OnModderDetected(pid, reason)
    for ID, t in ipairs(onEventFunctions[events.OnModderDetected]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnModderDetected)
        else 
            local out = callback_f(pid, reason) 
            if out == false then listener.remove(hash_s, events.OnModderDetected) end
        end
    end
end

function OnGameState(old, new)
    for ID, t in ipairs(onEventFunctions[events.OnGameState]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnGameState)
        else 
            local out = callback_f(old, new) 
            if out == false then listener.remove(hash_s, events.OnGameState) end 
        end
    end
end

function OnPlayerActive(pid)
    for ID, t in ipairs(onEventFunctions[events.OnPlayerActive]) do
        local hash_s, callback_f = t["hash"], t["callback"]
        if not callback_f then 
            log.error("EVENTS_LISTENER", string.format("Invalid callback in registered listener with hash: %s.", hash_s))
            listener.remove(hash_s, events.OnPlayerActive)
        else 
            local out = callback_f(pid) 
            if out == false then listener.remove(hash_s, events.OnPlayerActive) end
        end
    end
end