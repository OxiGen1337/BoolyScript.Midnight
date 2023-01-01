Main = Submenu.add_static_submenu("BoolyScript", "BS_Main_Submenu")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main_SubOption", Main)

task.executeAsScript("Load_BoolyScript", function ()
    require("Git/BoolyScript/pages/DrawUI/presets_mgr")
    require("Git/BoolyScript/pages/DrawUI/self")
    require("Git/BoolyScript/pages/DrawUI/weapon")
    require("Git/BoolyScript/pages/DrawUI/vehicle")
    require("Git/BoolyScript/pages/DrawUI/players")
    require("Git/BoolyScript/pages/DrawUI/network")
    require("Git/BoolyScript/pages/DrawUI/visuals")
    require("Git/BoolyScript/pages/DrawUI/world")
    require("Git/BoolyScript/pages/DrawUI/misc")
    require("Git/BoolyScript/pages/DrawUI/recovery")
    Configs.loadConfig()
end)

-- HOME_SUBMENU:add_click_option("Parse", "", function ()
--     -- local ped = PLAYER.PLAYER_PED_ID()
--     -- for i = 0, 11 do
--     --     local out = {
--     --         ["drawable"] = PED.GET_PED_DRAWABLE_VARIATION(ped, i),
--     --         ["texture"] = PED.GET_PED_TEXTURE_VARIATION(ped, i),
--     --         ["palette"] = PED.GET_PED_PALETTE_VARIATION(ped, i)
--     --     }
--     --     log.dbg(FILES.GET_HASH_NAME_FOR_COMPONENT(ped, i, out.drawable, out.texture))
-- 	-- end
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
--         out:write("\n\n\n\n\n\n\n\n\n\n\n\n\n" .. gender .. "\n")
--         for category, options in pairs(t) do
--             local g = "Male"
--             if gender == "female" then g = "Female" end
--             --out:write(string.format("inline std::vector<outfitCategory> %s {\n", category .. g))
-- --             out:write(string.format([[
-- -- .addSubmenu<staticSubmenu>(HASH("%s"), ~ESubIds::%s, [this](staticSubmenu* self)
-- --     {
-- --         for(auto& outfit : %s)
-- --         {
-- --             if (outfit.mVariations.size() == 1)
-- --             {
-- --                 self->add<clickOption>(0).setAction([this, &outfit](optionParameters const& p)
-- --                     {
-- --                         PED::_APPLY_SHOP_ITEM_TO_PED(PLAYER::PLAYER_PED_ID(), outfit.mVariations[0], false, true, true);
-- --                         PED::_UPDATE_PED_VARIATION(PLAYER::PLAYER_PED_ID(), true, true, true, true, true);
-- --                     }).setName(std::format("{} [{}]", outfit.mName, outfit.mVariations[0]));
-- --             }
-- --             else
-- --             {
-- --                 self->add<numericOption<decltype(outfit.mValue)>>(0, &outfit.mValue).setMin(0).setMax(outfit.mVariations.size() - 1).setExecuteOnChange(true).setAction([this, &outfit](optionParameters const& p)
-- --                     {
-- --                         PED::_APPLY_SHOP_ITEM_TO_PED(PLAYER::PLAYER_PED_ID(), outfit.mVariations[outfit.mValue], false, true, true);
-- --                         PED::_UPDATE_PED_VARIATION(PLAYER::PLAYER_PED_ID(), true, true, true, true, true);
-- --                     }).setName(outfit.mName);
-- --             }
-- --         }
-- --     })
-- -- ]], category, category .. g, category .. g))
--             out:write("self->add<subOption>(HASH(\"" .. category .."\"), ~ESubIds::".. category .. g .. ");\n")
--             -- for _, option in ipairs(options) do
--             --     out:write(string.format("\t{\"%s\", {%s}, 0},\n", option[1], option[3]))
--             -- end
--             -- out:write(string.format("};\n\n"))
--         end
--     end
--     out:close()
-- end)

