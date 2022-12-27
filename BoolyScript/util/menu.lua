require("Git/BoolyScript/system/tasks")
require("Git/BoolyScript/util/notify_system")
local json = require("Git/BoolyScript/modules/JSON")
local filesys = require("Git/BoolyScript/util/file_system")
local paths = require("Git/BoolyScript/globals/paths")

local options = {
    checkbox = {},
    button = {},
    sliderInt = {},
    sliderFloat = {},
    combo = {},
    comboEx = {},
    configIgnore = {},
    inputText = {},
    dynText = {},
    staticText = {},
}

local pages, blocks = {}, {}

GET_OPTIONS = function ()
    return options
end

GET_PAGES = function ()
    return pages
end

GET_BLOCKS = function ()
    return blocks
end

BLOCK_ALIGN_LEFT, BLOCK_ALIGN_RIGHT = 0, 1

local temp = menu

menu = {
    add_page = function (name_s, hash_s, icon_n)
        local data = temp.add_page(name_s, icon_n)
        pages[hash_s] = data
        return data
    end,

    add_mono_block = function (submenu_n, name_s, hash_s, align_n)
        local data = temp.add_mono_block(submenu_n, name_s, align_n)
        blocks[hash_s] = data
        return data
    end,

    add_button = function (submenu_n, name_s, hash_s, callback_f)
        local data = temp.add_button(submenu_n, name_s, function ()
            callback_f()
        end)
        options.button[hash_s] = data
        return data
    end,

    add_checkbox = function (submenu_n, name_s, hash_s, callback_f)
        local data = temp.add_checkbox(submenu_n, name_s, callback_f)
        options.checkbox[hash_s] = data
        return data
    end,

    add_looped_option = function (submenu_n, name_s, hash_s, tickDelay_n, callback_f, on_finish_f)
        local data = temp.add_checkbox(submenu_n, name_s, function (data, state)
            if state then 
                task.createTask(hash_s, tickDelay_n, nil, function (count)
                    callback_f(data, state, count)
                end)
            else
                task.removeTask(hash_s)
                if on_finish_f then on_finish_f() end
            end
        end)
        options.checkbox[hash_s] = data
        return data
    end,

    add_combo = function (submenu_n, name_s, hash_s, value_t, callback_f)
        local data = temp.add_combo(submenu_n, name_s, value_t, function (data, pos)
            callback_f(data, pos)
        end)
        options.combo[hash_s] = data
        return data
    end,

    add_combo_ex = function (submenu_n, name_s, hash_s, text_getter_f, index_getter_f)
        local data = temp.add_combo_ex(submenu_n, name_s, function (data, index)
           return text_getter_f(data, index)
        end, index_getter_f)
        options.comboEx[hash_s] = data
        return data
    end,

    add_static_text = function (submenu_n, name_s, hash_s)
        local data = temp.add_static_text(submenu_n, name_s)
        options.staticText[hash_s] = data
        return data
    end,

    add_dynamic_text = function (submenu_n, hash_s, getter_f)
        local data = temp.add_dynamic_text(submenu_n, getter_f)
        options.dynText[hash_s] = data
        return data
    end,

    add_slider_int = function (submenu_n, name_s, hash_s, min_n, max_n, callback_f)
        local data = temp.add_slider_int(submenu_n, name_s, min_n, max_n, callback_f)
        options.sliderInt[hash_s] = data
        return data
    end,

    add_slider_float = function (submenu_n, name_s, hash_s, min_n, max_n, callback_f)
        local data = temp.add_slider_float(submenu_n, name_s, min_n, max_n, callback_f)
        options.sliderFloat[hash_s] = data
        return data
    end,

    add_input_text = function (submenu_n, name_s, hash_s, callback_f)
        local data = temp.add_input_text(submenu_n, name_s, callback_f)
        options.inputText[hash_s] = data
        return data
    end,

    delete_page = function (handle_n)
        temp.delete_page(handle_n)
    end,
}

menu.saveConfig = function ()
    local configTable = {
        checkbox = {},
        combo = {},
        sliderInt = {},
        sliderFloat = {},
    }
    for name, optionID in pairs(options.checkbox) do
        configTable.checkbox[name] = optionID:get()
    end
    for name, optionID in pairs(options.combo) do
        configTable.combo[name] = optionID:get()
    end
    for name, optionID in pairs(options.sliderInt) do
        configTable.sliderInt[name] = optionID:get()
    end
    for name, optionID in pairs(options.sliderFloat) do
        configTable.sliderFloat[name] = optionID:get()
    end
    do
        local file = io.open(paths.files.config, "w+")
        file:write(json:encode_pretty(configTable))
        file:close()
    end
    notify.success("BoolyScript", "Config has been saved", GET_NOTIFY_ICONS().configs)
end

menu.loadConfig = function (isInit)
    if not filesys.doesFileExist(paths.files.config) then return end
    local file = io.open(paths.files.config, 'r')    
    local configTable = json:decode(file:read("*all"))
    file:close()
    if isInit and not configTable.checkbox['Init_AutoLoadConfig'] then return end
    for name, value in pairs(configTable.checkbox) do
        if options.checkbox[name] then
            options.checkbox[name]:set(value)
        end
    end
    for name, value in pairs(configTable.combo) do
        if options.combo[name] then
            options.combo[name]:set(value)
        end
    end
    for name, value in pairs(configTable.sliderInt) do
        if options.sliderInt[name] then
            options.sliderInt[name]:set(value)
        end
    end
    for name, value in pairs(configTable.sliderFloat) do
        if options.sliderFloat[name] then
            options.sliderFloat[name]:set(value)
        end
    end
    notify.success("BoolyScript", "Config has been loaded", GET_NOTIFY_ICONS().configs)
end

-- END