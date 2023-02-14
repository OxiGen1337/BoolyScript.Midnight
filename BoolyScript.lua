
BSVERSION = "0.3"
DEBUG = true

local temp = require

function require(path)
    if DEBUG then
        return temp("Git/" .. path)
    end
    return temp(path)
end

require("BoolyScript/util/notify_system")
require("BoolyScript/system/on_tick")
require("BoolyScript/util/DrawUI")
filesys = require("BoolyScript/util/file_system")
require("BoolyScript/system/events_listener")
paths = require("BoolyScript/globals/paths")
require("BoolyScript/globals/stuff")
parse = require("BoolyScript/util/parse")
scripts = require("BoolyScript/rage/scripts")
callbacks = require("BoolyScript/rage/callbacks")
features = require("BoolyScript/rage/features")
json = require("BoolyScript/modules/JSON")
gui = require("BoolyScript/globals/gui")

listener.register("BS_Init", GET_EVENTS_LIST().OnInit, function ()
    log.init("Loading BoolyScript...")
    log.init(string.format("Version -> [Midnight] [%s].", BSVERSION))
    log.init("Verifying required directories...")
    do
        local t = {
            paths.folders.user,
            paths.folders.outfits,
            -- paths.folders.chat_spammer,
            paths.folders.loadouts,
            paths.folders.logs,
            paths.folders.misc,
        }
        for _, path in ipairs(t) do
            if not fs.directory_exists(path) then 
                if not filesys.createDir(path) then
		            log.error("File system", "Failed to create directory with path:\n\t" .. path .. "\n\tPlease, create that folder by yourself.")
                end
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
        parse.json(paths.files.peds, function (content)
            ParsedFiles['peds'] = content
        end)
        parse.json(paths.files.vehicles, function (content)
            ParsedFiles['vehicles'] = content
        end)
        parse.txt(paths.files.objects, function (content)
            ParsedFiles['objects'] = content
        end)
    end
    log.init("Loading localizations...")
    do
        Localizations.russian = require("BoolyScript/localization/russian")
        Localizations.chinese = require("BoolyScript/localization/chinese")
        Localizations.custom = require("BoolyScript/localization/custom")
    end
    do -- Loading all pages added in 'pages' folder; it only loads init.lua so that file has to require everything that's in the page
        local path = filesys.getInitScriptPath() .. '\\BoolyScript\\pages'
        path = path:gsub("\\\\lua", "\\lua")
        for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
            if filesys.doesFileExist(path .. "\\" .. line .. "\\" .. "init.lua") then
                log.init(string.format("Initializing \'%s\' page...", line))
                require("BoolyScript/pages/" .. line .. "/" .. "init")
            end
        end
    end
    task.executeAsScript("Load_Config", function ()
        Configs.loadConfig()
        HotkeyService.loadHotkeys()
    end)
end)
