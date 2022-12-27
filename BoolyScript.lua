require("Git/BoolyScript/util/menu")
require("Git/BoolyScript/util/DrawUI")
require("Git/BoolyScript/system/on_tick")
local fs = require("Git/BoolyScript/util/file_system")
require("Git/BoolyScript/system/events_listener")
local paths = require("Git/BoolyScript/globals/paths")
require("Git/BoolyScript/globals/stuff")
local parse = require("Git/BoolyScript/util/parse")

listener.register("BS_Init", GET_EVENTS_LIST().OnDone, function ()
    for _, handle in pairs(GET_PAGES()) do -- Pages cleanup after script unload
        menu.delete_page(handle)
    end
end)

BSVERSION = "[Midnight] [0.1 Beta]"

listener.register("BS_Init", GET_EVENTS_LIST().OnInit, function ()
    log.init("Loading BoolyScript...")
    log.init(string.format("Version -> %s.", BSVERSION))
    log.init("Verifying required directories...")
    do
        local t = {
            paths.folders.user,
            paths.folders.translations,
            paths.folders.outfits,
            paths.folders.chat_spammer,
            paths.folders.loadouts,
            paths.folders.logs,
        }
        for _, path in ipairs(t) do
            if not fs.doesFolderExist(path) then 
                fs.createDir(path)
                --log.dbg(path)
            end
        end
    end
    log.init("Parsing \'.json\' data...")
    thread.create(function ()        
        parse.json(paths.files.weapons, function (content)
            ParsedFiles["weapons"] = content
        end)
        parse.json(paths.files.weaponHashes, function (content)
            ParsedFiles['weaponHashes'] = content
        end)
    end)
    do -- Loading all pages added in 'pages' folder; it only loads init.lua so that file has to require everything that's in the page
        local path = fs.getInitScriptPath() .. '\\BoolyScript\\pages'
        path = path:gsub("\\\\lua", "\\lua")
        for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
            if fs.doesFileExist(path .. "\\" .. line .. "\\" .. "init.lua") then
                log.init(string.format("Initializing \'%s\' page...", line))
                require("Git/BoolyScript/pages/" .. line .. "/" .. "init")
            end
        end
    end
end)
