require("BoolyScript/util/DrawUI")

Main = Submenu.add_static_submenu("BoolyScript", "BS_Main_Submenu")
HOME_SUBMENU:add_sub_option("BoolyScript", "BS_Main_SubOption", Main)

require("BoolyScript/pages/DrawUI/self")
require("BoolyScript/pages/DrawUI/vehicle")
require("BoolyScript/pages/DrawUI/network")
require("BoolyScript/pages/DrawUI/players")
require("BoolyScript/pages/DrawUI/presets_mgr")



