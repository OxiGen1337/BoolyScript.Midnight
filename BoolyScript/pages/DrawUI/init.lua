require("BoolyScript/util/DrawUI")

Main = Submenu.add_static_submenu("BoolyScript", "BS_Main")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main", Main)

task.executeAsScript("Loads_DrawUI", function ()
    require("BoolyScript/pages/DrawUI/presets_mgr")
    require("BoolyScript/pages/DrawUI/self")
    require("BoolyScript/pages/DrawUI/weapon")
    require("BoolyScript/pages/DrawUI/vehicle")
    require("BoolyScript/pages/DrawUI/network")
    require("BoolyScript/pages/DrawUI/players")
    require("BoolyScript/pages/DrawUI/visuals")
    require("BoolyScript/pages/DrawUI/world")
    require("BoolyScript/pages/DrawUI/misc")
    require("BoolyScript/pages/DrawUI/recovery")
end)

-- local t = {}

-- HOME_SUBMENU:add_click_option("Check", "", function ()
--     for _, option in ipairs(GET_OPTIONS()) do
--         if not option.translationIgnore and not t[option.hash] then
--             log.dbg(string.format("[\"%s\"] = \"%s\",", option.hash, option.name))
--             t[tostring(option.hash)] = true
--         end
--     end
-- end)