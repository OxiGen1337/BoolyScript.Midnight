require("BoolyScript/util/DrawUI")

V2 = Submenu.add_static_submenu("BoolyUnlocker", "BS_Recovery_V2")
HOME_SUBMENU:add_sub_option("BoolyUnlocker", "BS_Recovery_V2", V2):setHint("Recovery options are risky and may lead to account suspension")
ST = Submenu.add_static_submenu("BoolyStatEditor", "BS_StatEditor")
HOME_SUBMENU:add_sub_option("BoolyStatEditor", "BS_StatEditor", ST)

require("BoolyScript/pages/DrawUI_Recovery/include")
require("BoolyScript/pages/DrawUI_Recovery/main")
require("BoolyScript/pages/DrawUI_Recovery/stat-editor")