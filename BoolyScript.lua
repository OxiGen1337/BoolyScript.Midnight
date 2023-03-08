BSVERSION = "0.5"
-- PATCH = "1.66"
DEBUG = false

do
    local require_temp = require

    function require(path)
        if DEBUG then
            return require_temp("Git/" .. path)
        end
        return require_temp(path)
    end
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

-- if NETWORK._GET_ONLINE_VERSION() ~= PATCH then
--     notify.fatal("BoolyScript", string.format("You're using the newest game version: %s.\nScript is updated for: %s!", NETWORK._GET_ONLINE_VERSION(), PATCH))
--     log.error("BoolyScript", string.format("You're using the newest game version: %s. Script is updated for: %s!", NETWORK._GET_ONLINE_VERSION(), PATCH))
-- end

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
    -- log.init("Loading localizations...")
    -- do
    --     Localizations.russian = require("BoolyScript/localization/russian")
    --     Localizations.chinese = require("BoolyScript/localization/chinese")
    --     Localizations.custom = require("BoolyScript/localization/custom")
    -- end
    -- if not native.is_invoker_ready() then 
    --     notify.warning("Native", "Native invoker is not ready yet.\nWaiting for the game to completely load.")
    --     log.warning("Native", "Native invoker is not ready yet. Waiting for the game to completely load.")
    -- end
    task.executeAsScript("Init_LoadPages", function () -- Loading all pages added in 'pages' folder; it only loads init.lua so that file has to require everything that's in the page
        log.init("Loading modules from 'BoolyScript\\pages'...")
        local path = filesys.getInitScriptPath() .. '\\BoolyScript\\pages'
        path = path:gsub("\\\\lua", "\\lua")
        for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
            if filesys.doesFileExist(path .. "\\" .. line .. "\\" .. "init.lua") then
                log.init(string.format("Initializing \'%s\' page...", line))
                require("BoolyScript/pages/" .. line .. "/" .. "init")
            end
        end
        HOME_SUBMENU:add_separator("Services", "Home_Services")
        HOME_SUBMENU:add_click_option("Stop script", "Home_StopScript", function ()
            utils.stop_script()
        end)
        HOME_SUBMENU:add_click_option("Reload script", "Home_ReloadScript", function ()
            utils.reload_script()
        end)
        Configs.loadConfig()
        HotkeyService.loadHotkeys()
    end)
    do
        local a=os.date('%m/%d')if a=='12/31'then notify.important("Holidays", "Happy New Year!")elseif a=='01/01'then notify.important("Holidays", "Happy New Year!")elseif a=='01/07'then notify.important("Holidays", "Merry Christmas!")elseif a=='02/23'then notify.important("Holidays", "Happy Defender of the Fatherland Day!")elseif a=='03/08'then notify.important("Holidays", "Happy International Women Day!")elseif a=='03/18'then notify.important("Holidays", "Happy Day of Accession of Crimea to the Russian Federation!")elseif a=='03/27'then notify.important("Holidays", "Happy Day of the National Guard Troops of the Russian Federation!")elseif a=='04/01'then notify.important("Holidays", "You are ugly!")elseif a=='04/16'then notify.important("Holidays", "Happy Easter!")elseif a=='05/09'then notify.important("Holidays", "Happy Victory Day of the Soviet army and people over Nazi Germany in the Second World War!")elseif a=='06/12'then notify.important("Holidays", "Happy Russia Day!")elseif a=='08/22'then notify.important("Holidays", "Happy Day of the State Flag of the Russian Federation!")elseif a=='09/01'then notify.important("Holidays", "Why not at school bro?")elseif a=='11/04'then notify.important("Holidays", "Happy National Unity Day!")end
    end
end)