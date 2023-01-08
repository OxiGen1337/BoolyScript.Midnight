require("BoolyScript/util/DrawUI")

Main = Submenu.add_static_submenu("BoolyScript", "BS_Main_Submenu")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main_SubOption", Main)

task.executeAsScript("Load_Submenus", function ()
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

-- HOME_SUBMENU:add_click_option("Parse & Crop peds", "", function ()
--     parse.json(paths.files.peds, function (content)
--         local out = {}
--         for _, pedInfo in ipairs(content) do
--             local new = {
--                 name = pedInfo["Name"] or "Unknown",
--                 hash = pedInfo["Hash"] or 0,
--                 type = pedInfo["Pedtype"] or "Unsorted"
--             }
--             table.insert(out, new)
--         end
--         local file = io.open("C:\\Users\\dimon\\Downloads\\lua\\Git\\BoolyScript\\dumps\\peds_new.json", "w+")
--         file:write(json:encode_pretty(out))
--         file:close()
--     end)
-- end)
