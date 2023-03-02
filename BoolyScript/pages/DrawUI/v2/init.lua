V2 = Submenu.add_static_submenu("V2", "BS_Recovery_V2")
Recovery:add_separator("RISKY", "BS_Recovery_FunnyStuff")
Recovery:add_sub_option("V2", "BS_Recovery_V2", V2):setHint("V2 options are risky and may lead to account suspension")

require("BoolyScript/pages/DrawUI/v2/include")
require("BoolyScript/pages/DrawUI/v2/main")