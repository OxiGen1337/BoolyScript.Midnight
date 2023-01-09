local activeTasks = {}

GET_ACTIVE_TASKS = function ()
    return activeTasks
end

task = {}

task.createTask = function (hash_s, delay_n, count_n, callback_f)
    if task.exists(hash_s) then
        return log.error(string.format("[TASKS] Failed to create task with name: %s | Task already exists.", hash_s))
    end
    table.insert(activeTasks, {hash = hash_s, delay = delay_n, callback = callback_f, count = count_n})
    -- log.dbg(string.format("[TASKS] Created task with name \'%s\'.", hash_s))
    return true
end

task.executeAsScript = function (hash_s, callback_f)
    if task.exists(hash_s) then
        return log.error(string.format("[TASKS] Failed to create task with name: %s | Task already exists.", hash_s))
    end
    table.insert(activeTasks, {hash = hash_s, delay = 0.0, callback = callback_f, count = 1})
    -- log.dbg(string.format("[TASKS] Created as script execution task \'%s\'.", hash_s))
    return true
end

task.removeTask = function (hash_s)
    for ID, t in ipairs(activeTasks) do
        if t["hash"] == hash_s then
            table.remove(activeTasks, ID)
            -- log.dbg("[TASKS] " .. string.format("Successfully removed task with name \'%s\'.", hash_s))
            return true
        end
    end
    log.error(string.format("[TASKS] Failed to remove task with name \'%s\' | Task doesnt exist.", hash_s))
    return true
end

task.setCallback = function (hash_s, callback_f)
    for ID, t in ipairs(activeTasks) do
        if t["hash"] == hash_s then
            t.callback = callback_f
            return true
        end
    end
    log.error(string.format("[TASKS] Failed to set callback for task with name \'%s\' | Task doesnt exist.", hash_s))
    return true
end

task.setDelay = function (hash_s, delay_n)
    for ID, t in ipairs(activeTasks) do
        if t["hash"] == hash_s then
            t.delay = delay_n
            return true
        end
    end
    log.error(string.format("[TASKS] Failed to set delay for task with name \'%s\' | Task doesnt exist.", hash_s))
    return true
end

task.setCount = function (hash_s, count_n)
    for ID, t in ipairs(activeTasks) do
        if t["hash"] == hash_s then
            t.count = count_n
            return true
        end
    end
    log.error(string.format("[TASKS] Failed to set count for task with name \'%s\' | Task doesnt exist.", hash_s))
    return true
end

task.exists = function (hash_s)
    local tasks = activeTasks
    for _, t in ipairs(tasks) do
        if t["hash"] == hash_s then
            return true
        end
    end
    return false
end