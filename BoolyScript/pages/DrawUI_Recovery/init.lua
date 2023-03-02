require("BoolyScript/util/DrawUI")

V2 = Submenu.add_static_submenu("BoolyUnlocker", "BS_Recovery_V2")
HOME_SUBMENU:add_sub_option("BoolyUnlocker", "BS_Recovery_V2", V2):setTags({{"[New]", 255, 5, 88}}):setHint("Recovery options are risky and may lead to account suspension")
ST = Submenu.add_static_submenu("BoolyStatEditor", "BS_StatEditor")
HOME_SUBMENU:add_sub_option("BoolyStatEditor", "BS_StatEditor", ST):setTags({{"[Beta]", 20, 217, 197}})

task.executeAsScript("Load_RecoveryV2", function ()
    require("BoolyScript/pages/DrawUI_Recovery/include")
    require("BoolyScript/pages/DrawUI_Recovery/main")
    require("BoolyScript/pages/DrawUI_Recovery/stat-editor")
end)
--11