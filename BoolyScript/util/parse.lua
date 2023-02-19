local parse = {}

parse.json = function (path_s, callback_f)
    if not filesys.doesFileExist(path_s) then 
        -- log.error("PARSE", string.format("Failed to parse: %s | File doesnt exist.", path_s))
        return nil
    end
    local file = io.open(path_s, "r")
    local raw = file:read("*all")
    local content = json:decode(raw) or {}
    file:close()
    if callback_f then callback_f(content) end
    return content
end

parse.txt = function (path_s, callback_f)
    if not filesys.doesFileExist(path_s) then 
        -- log.error("PARSE", string.format("Failed to parse: %s | File doesnt exist.", path_s))
        return nil
    end
    local content = {}
    for line in io.lines(path_s) do
        table.insert(content, line)
    end
    if callback_f then callback_f(content) end
    return content
end

return parse