require("Git/BoolyScript/util/menu")
require("Git/BoolyScript/system/events_listener")

local page = GET_PAGES()['BS_Main']
local self = menu.add_mono_block(page, "Settings", "BS_Settings", BLOCK_ALIGN_RIGHT)

menu.add_button(self, "Load config", "BS_Settings_LoadConfig", function ()
    thread.create(function ()
        menu.loadConfig(false)
    end)
end)

menu.add_button(self, "Save config", "BS_Settings_SaveConfig", function ()
    thread.create(function ()
        menu.saveConfig()
    end)
end)

menu.add_checkbox(self, "Auto load config", "Init_AutoLoadConfig")

listener.register("Init_LoadConfig", GET_EVENTS_LIST().OnInit, function ()
    menu.loadConfig(true)
end)



-- END