require("BoolyScript/util/notify_system")

local activeTasks = {}

GET_ACTIVE_TASKS = function ()
    return activeTasks
end

task = {}

task.createTask = function (hash_s, delay_n, count_n, callback_f)
    if activeTasks[hash_s] then 
        log.error("TASKS", string.format("Task with hash: \'%s\' already exists.", hash_s))
        return false
    end
    activeTasks[hash_s] = {delay = delay_n, callback = callback_f, count = count_n}
    log.dbg(string.format("[TASKS] Created task with name \'%s\'.", hash_s))
    return true
end

task.removeTask = function (hash_s)
    if not activeTasks[hash_s] then
        log.error("TASKS", string.format("Task with hash: \'%s\' doesnt exist.", hash_s))
        return false
    end
    activeTasks[hash_s] = nil
    log.dbg(string.format("[TASKS] Removed task with name \'%s\'.", hash_s))
    return true
end

task.setCallback = function (hash_s, callback_f)
    if not activeTasks[hash_s] then
        log.error("TASKS", string.format("Task with hash: \'%s\' doesnt exist.", hash_s))
        return false
    end
    activeTasks[hash_s].callback = callback_f
    return true
end

task.setDelay = function (hash_s, delay_n)
    if not activeTasks[hash_s] then
        log.error("TASKS", string.format("Task with hash: \'%s\' doesnt exist.", hash_s))
        return false
    end
    activeTasks[hash_s].delay = delay_n
    return true
end

task.setCount = function (hash_s, count_n)
    if not activeTasks[hash_s] then
        log.error("TASKS", string.format("Task with hash: \'%s\' doesnt exist.", hash_s))
        return false
    end
    activeTasks[hash_s].count = count_n
    return true
end

task.exists = function (hash_s)
    return not (activeTasks[hash_s] == nil)
end