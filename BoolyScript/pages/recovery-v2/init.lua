require("BoolyScript/util/DrawUI")

V2 = Submenu.add_static_submenu("Recovery V2", "BS_Recovery_V2")
HOME_SUBMENU:add_sub_option("Recovery V2", "BS_Recovery_V2", V2):setTags({{"[New]", 255, 5, 88}}):setHint("V2 options are risky and may lead to account suspension")
ST = Submenu.add_static_submenu("Stat Editor", "BS_StatEditor")
HOME_SUBMENU:add_sub_option("Stat Editor", "BS_StatEditor", ST):setTags({{"[Beta]", 20, 217, 197}})

task.executeAsScript("Load_RecoveryV2", function ()
    require("BoolyScript/pages/recovery-v2/include")
    require("BoolyScript/pages/recovery-v2/main")
    require("BoolyScript/pages/recovery-v2/stat-editor")
end)
--11