Misc = Submenu.add_static_submenu("Misc", "BS_Misc_Submenu")
Main:add_sub_option("Misc", "BS_Misc_SubOption", Misc)

Misc:add_click_option("Unlock all achievements", "BS_Misc_UnlockAllAchievs", function()
    for ID = 1, 78 do
        PLAYER.GIVE_ACHIEVEMENT_TO_PLAYER(ID)
    end
    notify.success("Achievements", "Unlocked successfully")
end)

Misc:add_looped_option("Remove transaction error", "BS_Misc_RemoveTransactionError", 0.0, function ()
    scripts.globals.removeTransactionError()
end)

Misc:add_click_option("Force stat save", "BS_Misc_ForceStatSave", function()
    STATS.STAT_SAVE(0, 0, 3, 0)
    notify.success("Force stat save", "Success")
end)