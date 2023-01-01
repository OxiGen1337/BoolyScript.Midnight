-- require("Git/BoolyScript/util/menu")
require("Git/BoolyScript/util/DrawUI")
require("Git/BoolyScript/util/notify_system")
require("Git/BoolyScript/system/on_tick")
filesys = require("Git/BoolyScript/util/file_system")
require("Git/BoolyScript/system/events_listener")
paths = require("Git/BoolyScript/globals/paths")
require("Git/BoolyScript/globals/stuff")
parse = require("Git/BoolyScript/util/parse")
scripts = require("Git/BoolyScript/rage/scripts")
features = require("Git/BoolyScript/rage/features")
json = require("Git/BoolyScript/modules/JSON")
gui = require("Git/BoolyScript/globals/gui")


-- listener.register("BS_Init", GET_EVENTS_LIST().OnDone, function ()
--     for _, handle in pairs(GET_PAGES()) do -- Pages cleanup after script unload
--         menu.delete_page(handle)
--     end
-- end)

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
            if not filesys.doesFolderExist(path) then 
                filesys.createDir(path)
                --log.dbg(path)
            end
        end
    end
    log.init("Parsing \'.json\' data...")
    do
        parse.json(paths.files.weapons, function (content)
            ParsedFiles["weapons"] = content
        end)
        parse.json(paths.files.weaponHashes, function (content)
            ParsedFiles['weaponHashes'] = content
        end)
    end
    do -- Loading all pages added in 'pages' folder; it only loads init.lua so that file has to require everything that's in the page
        local path = filesys.getInitScriptPath() .. '\\BoolyScript\\pages'
        path = path:gsub("\\\\lua", "\\lua")
        for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
            if filesys.doesFileExist(path .. "\\" .. line .. "\\" .. "init.lua") then
                log.init(string.format("Initializing \'%s\' page...", line))
                require("Git/BoolyScript/pages/" .. line .. "/" .. "init")
            end
        end
    end
end)
