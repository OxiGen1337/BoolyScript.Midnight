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
