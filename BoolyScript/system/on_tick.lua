require("Git/BoolyScript/system/tasks")
require("Git/BoolyScript/util/notify_system")
require("Git/BoolyScript/system/events_listener")

local timers = {}
local count = {}

local function n(value)
    if type(value) == "number" then return value end
    return 0
end

local function removeTask(hash)
    task.removeTask(hash)
    timers[hash] = nil
    count[hash] = nil
end

listener.register("System_Tick", GET_EVENTS_LIST().OnFeatureTick, function ()    
    for hash, params in pairs(GET_ACTIVE_TASKS()) do
        local timerCheck = (not timers[hash]) or (os.clock() - timers[hash] >= params.delay)
        local countCheck = (not count[hash]) or (count[hash] < n(params.count)) or (not params.count)
        if countCheck then
            if timerCheck then
                if type(params.callback) == "function" then
                    if not count[hash] then 
                        count[hash] = 1
                    else 
                        count[hash] = count[hash] + 1 
                    end 
                    local out = params.callback(count[hash])
                    if out == false then removeTask(hash) end
                    timers[hash] = os.clock()
                else
                    log.error("TASKS", string.format("Task with hash \'%s\' has the invalid callback.", hash))
                    removeTask(hash)
                end
            end
        elseif not countCheck and count[hash] >= n(params.count) then
            --log.dbg(string.format("[TASKS] Ended task with hash \'%s\' due to reaching its restrictions.", hash))
            removeTask(hash)
        end
    end
end)