Main = Submenu.add_static_submenu("BoolyScript", "BS_Main")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main", Main)

task.executeAsScript("Load_DrawUI", function ()
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
