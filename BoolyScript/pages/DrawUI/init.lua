Main = Submenu.add_static_submenu("BoolyScript", "BS_Main_Submenu")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main_SubOption", Main)

require("Git/BoolyScript/pages/DrawUI/self")
require("Git/BoolyScript/pages/DrawUI/weapon")
require("Git/BoolyScript/pages/DrawUI/vehicle")
require("Git/BoolyScript/pages/DrawUI/players")
require("Git/BoolyScript/pages/DrawUI/network")
require("Git/BoolyScript/pages/DrawUI/presets_mgr")
require("Git/BoolyScript/pages/DrawUI/visuals")
require("Git/BoolyScript/pages/DrawUI/world")
require("Git/BoolyScript/pages/DrawUI/misc")



task.executeAsScript("Settings_LoadConfig", function ()
    Configs.loadConfig()
end)

-- HOME_SUBMENU:add_click_option("Parse", "", function ()
--     local file = io.open("C:\\Users\\dimon\\Downloads\\lua\\data.json", "r")
--     local raw = file:read("*all")
--     local content = json:decode(raw)
--     file:close()
--     local out = io.open("C:\\Users\\dimon\\Downloads\\lua\\data2.json", "w+")
--     local categories = {
--         male = {},
--         female = {}
--     }
--     for gender, t in pairs(content) do
--         for _, outfit_t in ipairs(t) do
--             local name = "Untitled"
--             if outfit_t["name"] then name = outfit_t["name"] end
--             local description = ""
--             if outfit_t['description'] then description = outfit_t["description"] end
--             local category = ""
--             if outfit_t['category'] then category = outfit_t["category"] end
--             local variations = ""
--             if outfit_t["variations"] then
--                 variations = table.concat(outfit_t["variations"], ", ")
--             else
--                 variations = outfit_t["hash"]
--             end
--             if not categories[gender][category] then categories[gender][category] = {} end
--             table.insert(categories[gender][category], {name, description, variations})
--             -- print(string.format("{\"%s\", \"%s\", \"%s\", {%s}},\n", name, description, category, variations))
--         end
--     end
--     for gender, t in pairs(categories) do
--         out:write(gender .. "\n")
--         for category, options in pairs(t) do
--             out:write(category .. "\n")
--             for _, option in ipairs(options) do
--                 out:write(string.format("{\"%s\", \"%s\", {%s}},\n", option[1], option[2], option[3]))
--             end
--         end
--     end
--     out:close()
-- end)