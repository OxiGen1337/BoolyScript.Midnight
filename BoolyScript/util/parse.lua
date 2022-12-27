local json = require("BoolyScript/modules/JSON")
require("BoolyScript/util/notify_system")
local fs = require("BoolyScript/util/file_system")

local parse = {}

parse.json = function (path_s, callback_f)
    if not fs.doesFileExist(path_s) then 
        log.error("PARSE", string.format("Failed to parse: %s | File doesnt exist.", path_s))
        return nil
    end
    local file = io.open(path_s, "r")
    local raw = file:read("*all")
    local content = json:decode(raw)
    file:close()
    if callback_f then callback_f(content) end
    return content
end

return parse