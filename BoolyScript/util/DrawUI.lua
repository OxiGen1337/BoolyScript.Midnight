local paths = require("Git/BoolyScript/globals/paths")
require("Git/BoolyScript/globals/stuff")
require("Git/BoolyScript/system/events_listener")

local config = {
    width = 325,
    height = 500,
    optionHeight = 30,
    selectedOption = 1,
    activeSubmenu = nil,
    maxOptions = 12,
    scrollOffset = 0,
    isInputBoxDisplayed = false,
    inputBoxText = "",
    inputBoxHeight = 70,
    inputBoxWidth = 150,
    isOpened = true,
    path = {},
    inputDelay = 0.3,
    test = 0.0,
    scrollerSmooth = 2.5,
    isActionDown = false,
    enabelSmoothScroller = false,
    offset_x = 1400,
    offset_y = 300,
}

Stuff.controlsState = {
    [104] = {false, nil, nil},
    [98] = {false, nil, nil},
    [96] = {false, nil, nil},
    [101] = {false, nil, nil},
    [100] = {false, nil, nil},
    [102] = {false, nil, nil},
}

local id_to_key = {
	[32] = " ",

	[65] = "a",
	[66] = "b",
	[67] = "c",
	[68] = "d",
	[69] = "e",
	[70] = "f",
	[71] = "g",
	[72] = "h",
	[73] = "i",
	[74] = "j",
	[75] = "k",
	[76] = "l",
	[77] = "m",
	[78] = "n",
	[79] = "o",
	[80] = "p",
	[81] = "q",
	[82] = "r",
	[83] = "s",
	[84] = "t",
	[85] = "u",
	[86] = "v",
	[87] = "w",
	[88] = "x",
	[89] = "y",
	[90] = "z",

	[48] = "0",
	[49] = "1",
	[50] = "2",
	[51] = "3",
	[52] = "4",
	[53] = "5",
	[54] = "6",
	[55] = "7",
	[56] = "8",
	[57] = "9",

	[189] = "-",
	[187] = "=",
}

local to_upper = {
	["-"] = "_",
	["="] = "+",
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
}

local materials = {}

materials.header = draw.create_texture_from_file(paths.files.imgs.header)
materials.bg = draw.create_texture_from_file(paths.files.imgs.bg)
materials.selected = draw.create_texture_from_file(paths.files.imgs.selected)
materials.footer = draw.create_texture_from_file(paths.files.imgs.footer)
materials.hintBox = draw.create_texture_from_file(paths.files.imgs.hintBox)
materials.footerArrows = draw.create_texture_from_file(paths.files.imgs.footerArrows)
materials.toggleOn = draw.create_texture_from_file(paths.files.imgs.toggleOn)
materials.toggleOff = draw.create_texture_from_file(paths.files.imgs.toggleOff)
materials.sub = draw.create_texture_from_file(paths.files.imgs.sub)


OPTIONS = {
    CLICK = 1,
    BOOL = 2,
    NUM = 3,
    FLOAT = 4,
    CHOOSE = 5,
    SEPARATOR = 6,
    STATE_BAR = 7,
    TEXT_INPUT = 8,
    SUB = 9,
}

local submenus = {}

Submenu = {
    ID = nil,
    name = nil,
    hash = "",
    isDynamic = false,
    options = {},
    selectedOption = 1,
    scrollOffset = 0,
    --for dynamic submenus
    indexGetter = nil,
    optionGetter = nil,
    getSubmenus = function ()
        return submenus
    end,
}
Submenu.__index = Submenu

Option = {
    ID = nil,
    submenu = nil,
    name = nil,
    hash = "",
    type = nil,
    value = nil,
    callback = nil,
    -- For choose and num options
    table = {},
    minValue = nil,
    maxValue = nil,
    step = 0,
    execOnSelection = nil,
    getter = nil,
    hint = "",
}
Option.__index = Option

function Submenu.add_static_submenu(name_s, hash_s)
    local submenu = setmetatable({}, Submenu)
    submenu.ID = #Submenu.getSubmenus() + 1
    submenu.name = name_s
    submenu.hash = hash_s
    submenu.isDynamic = false
    submenu.options = {}
    table.insert(submenus, submenu)
    return submenu
end

function Submenu.add_main_submenu(name_s, hash_s)
    local submenu = Submenu.add_static_submenu(name_s, hash_s)
    config.path[1] = submenu
    config.activeSubmenu = 1
    return submenu
end

function Submenu.add_dynamic_submenu(name_s, hash_s, indexGetter_f, optionGetter_f)
    local submenu = setmetatable({}, Submenu)
    submenu.ID = #Submenu.getSubmenus() + 1
    submenu.name = name_s
    submenu.hash = hash_s
    submenu.isDynamic = true
    submenu.indexGetter = indexGetter_f
    submenu.optionGetter = optionGetter_f
    submenu.options = {}
    table.insert(submenu, submenu)
    return submenu
end

function Option.new(submenu_mt, name_s, hash_s, type_n, value_n, callback_f)
    local option = setmetatable({}, Option)
    option.ID = #submenu_mt.options + 1
    option.name = name_s
    option.type = type_n
    option.hash = hash_s
    option.callback = callback_f
    option.value = value_n
    option.submenu = submenu_mt
    table.insert(submenu_mt.options, option)
    return option
end

function Submenu:add_sub_option(name_s, hash_s, submenu_mt, on_opened_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.SUB, nil, function ()
        config.activeSubmenu = submenu_mt.ID
        table.insert(config.path, submenu_mt)
        if on_opened_f then on_opened_f() end
    end)
    return option
end

function Submenu:setActive(state)
    if state then
        config.activeSubmenu = self.ID
        table.insert(config.path, self)
    else
        if config.activeSubmenu == self.ID then
            table.remove(config.path)
            config.activeSubmenu = config.path[#config.path]
        end
    end
    return self
end

function Submenu:isOpened()
    return config.activeSubmenu == self.ID
end

function Submenu:add_click_option(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.CLICK, nil, callback_f)
    return option
end

function Submenu:add_bool_option(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.BOOL, false, callback_f)
    return option
end

function Submenu:add_looped_option(name_s, hash_s, delay_n, callback_f, on_finish_f)
    local option = self:add_bool_option(name_s, hash_s, function (state)
        if state then
            task.createTask(hash_s, delay_n, nil, callback_f)
        else
            task.removeTask(hash_s)
            if on_finish_f then on_finish_f() end
        end
    end)
    return option
end

function Submenu:add_num_option(name_s, hash_s, min_n, max_n, step_n, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.NUM, 0, callback_f)
    option.minValue = min_n
    option.maxValue = max_n
    option.step = step_n
    return option
end

function Submenu:add_float_option(name_s, hash_s, min_n, max_n, step_n, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.FLOAT, 0.0, callback_f)
    option.minValue = min_n
    option.maxValue = max_n
    option.step = step_n
    return option
end

function Submenu:add_choose_option(name_s, hash_s, execOnSelection_b, table_t, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.CHOOSE, 1, callback_f)
    option.execOnSelection = execOnSelection_b
    option.table = table_t
    return option
end

function Submenu:add_separator(name_s, hash_s)
    local option = Option.new(self, name_s, hash_s, OPTIONS.SEPARATOR, nil, nil)
    return option
end

function Submenu:add_state_bar(name_s, hash_s, getter_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.STATE_BAR, nil, nil)
    option.getter = getter_f
    return option
end

function Submenu:add_text_input(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.TEXT_INPUT, nil, callback_f)
    option.value = ""
    return option
end

function Submenu:getName()
    return self.name
end

function Submenu:setName(name_s)
    if type(name_s) == "string" then
        self.name = name_s
        return self
    end
    log.error("DrawUI", "Wrong value for Submenu:setName() function.")
    return self
end

function Submenu:remove()
    if not self then return end
    for ID, sub in ipairs(submenus) do
        if sub.hash == self.hash then 
            table.remove(submenus, ID)
        end
    end
    for i = self.ID, #submenus do
        submenus[i].ID = submenus[i].ID - 1
    end
    self = nil
    return nil
end

-- OPTION METHODS

function Option:getValue()
    return self.value
end

function Option:setValue(value, ignoreCallback_b)
    if (self.type == OPTIONS.NUM or self.type == OPTIONS.FLOAT or self.type == OPTIONS.CHOOSE) and type(value) == "number" then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    elseif (self.type == OPTIONS.BOOL and type(value) == "boolean") then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    elseif (self.type == OPTIONS.CLICK) then
        if self.callback and not ignoreCallback_b then self.callback() end
        return self
    elseif (self.type == OPTIONS.TEXT_INPUT and type(value) == "string") then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    end
    log.error("DrawUI", "Wrong option type or value for Option:setValue() function.")
    return self
end

function Option:reset(ignoreCallback_b)
    if self.type == OPTIONS.NUM or self.type == OPTIONS.FLOAT then
        self.value = 0
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    elseif self.type == OPTIONS.CHOOSE then
        self.value = 1
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    elseif self.type == OPTIONS.BOOL then
        self.value = false
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    elseif self.type == OPTIONS.TEXT_INPUT then
        self.value = ""
        if self.callback and not ignoreCallback_b then self.callback(self.value) end
        return self
    end
    return self
end

function Option:setCallback(value)
    if type(value) == "function" then
        self.callback = value
        return self
    end
    log.error("DrawUI", "Wrong callback for Option:setCallback() function.")
    return self
end

function Option:setTable(table_t)
    if type(table_t) == "table" then
        self.table = table_t
        return self
    end
    log.error("DrawUI", "Wrong value for Option:setTable() function.")
    return self
end

function Option:getTable()
    return self.table
end

function Option:setName(name_s)
    if type(name_s) == "string" then
        self.name = name_s
        return self
    end
    log.error("DrawUI", "Wrong value for Option:setName() function.")
    return self
end

function Option:getName()
    return self.name
end

function Option:setLimits(min_n, max_n, step_n)
    if type(min_n) == "number" and type(max_n) == "number" and type(step_n) == "number" then
        self.minValue = min_n
        self.maxValue = max_n
        self.step = step_n
        return self
    end
    log.error("DrawUI", "Wrong values for Option:setLimits() function.")
    return self
end

function Option:setHint(text_s)
    if type(text_s) == "string" then
        self.hint = text_s
        return self
    end
    log.error("DrawUI", "Wrong value for Option:setHint() function.")
    return self
end

function Option:getHint()
    return self.hint
end

function Option:remove()
    if not self then return end
    for ID, opt in ipairs(self.submenu.options) do
        if opt.hash == self.hash then 
            table.remove(self.submenu.options, ID)
        end
    end
    for i = self.ID, #self.submenu.options do
        self.submenu.options[i].ID = self.submenu.options[i].ID - 1
    end
    self = nil
    return nil
end

local function toggleInputBox(state, option)
    if state then
        config.isInputBoxDisplayed = true
        config.isOpened = false
    else
        if option then
            if option.type == OPTIONS.FLOAT or option.type == OPTIONS.NUM then
                option.value = tonumber(config.inputBoxText)
                if option.callback then option.callback(option.value) end
            else
                option.value = config.inputBoxText
                if option.callback then option.callback(config.inputBoxText) end
            end
        end
        config.inputBoxText = ""
        config.isInputBoxDisplayed = false
        config.isOpened = true
    end
end

local function onControl(key, isDown, ignoreControlsState)
    local numZeroDelay = 0
    if Stuff.controlsState[key] and not ignoreControlsState then
        Stuff.controlsState[key][1] = isDown
        Stuff.controlsState[key][2] = os.clock()
        Stuff.controlsState[key][3] = os.clock() + config.inputDelay
    end
    if isDown then
        local submenu = config.path[#config.path]
        if key == 106 then
            config.isOpened = not config.isOpened
        end
        if config.isInputBoxDisplayed and id_to_key[key] then
            config.inputBoxText = config.inputBoxText .. id_to_key[key]
        end
        if key == 13 and config.isInputBoxDisplayed then -- ENTER
            local data = submenu.options[submenu.selectedOption]
            toggleInputBox(false, data)

        end
        if (key == 27 or key == 96) and config.isInputBoxDisplayed then -- escape / num0
            toggleInputBox(false)
            numZeroDelay = os.clock() + 0.1
        end 
        if key == 8 and config.isInputBoxDisplayed then -- BACKSPACE
            config.inputBoxText = config.inputBoxText:sub(1, -2)
        end
    end
    if not config.isOpened then return end
    if isDown then
        if (key == 8 or key == 96) and os.clock() > numZeroDelay then 
            if #config.path == 1 then
                config.isOpened = false
            else
                table.remove(config.path)
                numZeroDelay = 0
            end
        end
        if key == 104 then -- UP
            local submenu = config.path[#config.path]
            
            local function getClickableOption(selectedOption)
                if submenu.isDynamic then return selectedOption end
                if selectedOption < 1 then 
                    return getClickableOption(#submenu.options)
                end
                if submenu.options[selectedOption].type ~= OPTIONS.SEPARATOR and submenu.options[selectedOption].type ~= OPTIONS.STATE_BAR then
                    return selectedOption
                else
                    return getClickableOption(selectedOption - 1)
                end
            end

            if submenu.selectedOption > 1 then
                submenu.selectedOption = getClickableOption(submenu.selectedOption - 1)
                if submenu.selectedOption > config.maxOptions then
                    submenu.scrollOffset = submenu.selectedOption - config.maxOptions
                else
                    submenu.scrollOffset = 0
                end
            else
                submenu.selectedOption = getClickableOption(#submenu.options)
                if #submenu.options > config.maxOptions then
                    submenu.scrollOffset = submenu.selectedOption - config.maxOptions
                else
                    submenu.scrollOffset = 0
                end
            end

            config.isActionDown = false
            config.test = 0
        end
        if key == 98 then -- DOWN
            local submenu = config.path[#config.path]

            local function getClickableOption(selectedOption)
                if submenu.isDynamic then return selectedOption end
                if selectedOption > #submenu.options then 
                    return getClickableOption(1)
                end
                if (submenu.options[selectedOption].type ~= OPTIONS.SEPARATOR) and (submenu.options[selectedOption].type ~= OPTIONS.STATE_BAR) then
                    return selectedOption
                else
                    return getClickableOption(selectedOption + 1)
                end
            end

            if submenu.selectedOption < #submenu.options then
                submenu.selectedOption = getClickableOption(submenu.selectedOption + 1)
                if submenu.selectedOption > config.maxOptions then
                    submenu.scrollOffset = submenu.selectedOption - config.maxOptions
                else
                    submenu.scrollOffset = 0
                end
            else
                submenu.selectedOption = getClickableOption(1)
                if #submenu.options > config.maxOptions then
                    submenu.scrollOffset = 0
                else
                    submenu.scrollOffset = 0
                end
            end
            config.isActionDown = true
            config.test = 0.0
        end
        if key == 101 then -- ENTER
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.CLICK then
                    if selected.callback then selected.callback(selected) end
                elseif selected.type == OPTIONS.BOOL then
                    selected.value = not selected.value
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.NUM or selected.type == OPTIONS.FLOAT then
                    toggleInputBox(true, selected)
                    --selected.callback(selected.value)
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.callback then selected.callback(selected.table[selected.value], selected) end
                elseif selected.type == OPTIONS.SUB then
                    if selected.callback then selected.callback(selected) end
                elseif selected.type == OPTIONS.TEXT_INPUT then
                    toggleInputBox(true, selected)
                end
            end
        end
        if key == 100 then -- OPTION LEFT
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.NUM or selected.type == OPTIONS.FLOAT then
                    if selected.value - selected.step < selected.minValue then
                        selected.value = selected.maxValue + .0
                    else
                        selected.value = selected.value - selected.step + .0
                    end
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.value == 1 then
                        selected.value = #selected.table
                    else
                        selected.value = selected.value - 1
                    end
                    if selected.execOnSelection then
                        if selected.callback then selected.callback(selected.value, selected) end
                    end
                end
            end
        end
        if key == 102 then --OPTION RIGHT
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.NUM or selected.type == OPTIONS.FLOAT then
                    if selected.value + selected.step > selected.maxValue then
                        selected.value = selected.minValue + .0
                    else
                        selected.value = selected.value + selected.step + .0
                    end
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.value == #selected.table then
                        selected.value = 1
                    else
                        selected.value = selected.value + 1
                    end
                    if selected.execOnSelection then
                        if selected.callback then selected.callback(selected.value, selected) end
                    end
                end
            end
        end
    end
end

listener.register("DrawUI_controlsStateCheck", GET_EVENTS_LIST().OnFrame, function ()
    for key, data in pairs(Stuff.controlsState) do
        if data[1] and os.clock() - data[2] >= config.inputDelay and os.clock() - data[3] >= 0.1 then
            onControl(key, data[1], true)
            data[3] = os.clock()
        end
    end
end)

listener.register("DrawUI_controls", GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
    onControl(key, isDown, false)
end)

HOME_SUBMENU = Submenu.add_main_submenu("Home", "home_sub")

local settings = Submenu.add_static_submenu("Settings", "Main_Settings_Submenu") do
    HOME_SUBMENU:add_sub_option("Settings", "Main_Settings_SubOption", settings)
    settings:add_float_option("UI width", "Main_Settings_Width", 0.0, 800.0, 5.0, function (val)
        config.width = val
    end):setValue(config.width)
    settings:add_float_option("Option height", "Main_Settings_Height", 5.0, 40.0, 1.0, function (val)
        config.optionHeight = val
    end):setValue(config.optionHeight)
    settings:add_float_option("UI offset [X]", "Main_Settings_OffsetX", 0.0, draw.get_window_width(), 10.0, function (val)
        config.offset_x = val
    end):setValue(config.offset_x)
    settings:add_float_option("UI offset [Y]", "Main_Settings_OffsetY", 0.0, draw.get_window_height(), 10.0, function (val)
        config.offset_y = val
    end):setValue(config.offset_y)
    settings:add_bool_option("Smooth scroller [Beta]", "Main_Settings_SmoothScroller", function (state)
        config.enabelSmoothScroller = state
    end):setValue(true)
    settings:add_num_option("Renered options limit", "Main_Settings_Limit", 1, 25, 1, function (val)
        config.maxOptions = val
    end):setValue(config.maxOptions)
    settings:add_float_option("UI input delay", "Main_Settings_InputDelay", 0.0, 1.0, 0.05, function (val)
        config.inputDelay = val
    end):setValue(config.inputDelay)
end

listener.register("DrawUI_render", GET_EVENTS_LIST().OnFrame, function ()
    do
        if config.isInputBoxDisplayed then
            local lu = {
                x = draw.get_window_width()/2 - config.inputBoxWidth, 
                y = draw.get_window_height()/2 - config.inputBoxHeight, 
            }
            local rd = {
                x = draw.get_window_width()/2 + config.inputBoxWidth, 
                y = draw.get_window_height()/2 + config.inputBoxHeight, 
            }
            draw.set_color(0, 0, 0, 0, 255)
            draw.rect_filled(
                lu.x, lu.y, rd.x, rd.y
            )
            local ttl = "Type your text [English]..."
            draw.set_color(0, 255, 255, 255, 255)
            draw.text(
                (rd.x - (rd.x - lu.x)/2) - draw.get_text_size_x(ttl)/2,
                lu.y + 15,
                ttl
            )
            lu = { -- input box text area
                x = lu.x + 20,
                y = lu.y + draw.get_text_size_y(ttl) + 15 + 15,
            }
            rd = {
                x = rd.x - 20,
                y = lu.y + 40,
            }
            draw.set_color(0, 50, 50, 50, 255)
            draw.rect_filled(
                lu.x, 
                lu.y,
                rd.x, 
                rd.y
            )

            draw.set_color(0, 255, 255, 255, 255)
            draw.text(
                lu.x + 10,
                (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(config.inputBoxText)/2,
                config.inputBoxText
            )

            local footer = "Press Enter to close. ESC to cancel."
            draw.set_color(0, 255, 255, 255, 255)
            draw.text(
                (rd.x - (rd.x - lu.x)/2) - draw.get_text_size_x(footer)/2,
                rd.y + 15,
                footer
            )
        end
        
        if not config.isOpened then return end

        local submenu = config.path[#config.path]
        --if #submenu.options == 0 then table.remove(config.path) end
        --submenu = config.path[#config.path]

        local bg = {}
        bg.lu = {
            x = config.offset_x, 
            y = config.offset_y
        }
        bg.rd = {
            x = bg.lu.x + config.width, 
            y = bg.lu.y + #submenu.options*config.optionHeight
        }
        if #submenu.options > config.maxOptions then
            bg.rd.y = bg.lu.y + config.maxOptions*config.optionHeight
        end
        draw.set_color(0, 0, 0, 10, 255) -- BACKGROUND
        --draw.rect_filled(bg.lu.x, bg.lu.y, bg.rd.x, bg.rd.y)
        draw.texture(
            materials.bg,
            bg.lu.x, 
            bg.lu.y - config.optionHeight,
            config.width,
            bg.rd.y - bg.lu.y + config.optionHeight
        )
        draw.texture(
            materials.footer,
            bg.lu.x, 
            bg.rd.y,
            config.width,
            30
        )
        config.footerArrowsSize = 28.0
        draw.texture(
            materials.footerArrows,
            bg.lu.x + config.width/2 - config.footerArrowsSize/2 - 2, 
            bg.rd.y + 30/2 - config.footerArrowsSize/2, 
            config.footerArrowsSize + 2,
            config.footerArrowsSize
        )
        local pos = string.format("%i/%i", submenu.selectedOption, #submenu.options)
        draw.set_color(0, 255, 255, 255, 255) -- BACKGROUND
        
        draw.text(
            bg.rd.x - draw.get_text_size_x(pos) - 10,
            -- (bg.rd.y + 30 - config.optionHeight - (bg.rd.y - config.optionHeight - bg.rd.y)/2) - draw.get_text_size_y(pos)/2,
            (bg.lu.y - config.optionHeight) + config.optionHeight/2 - draw.get_text_size_y(pos)/2,
            pos
        )



        -- draw.set_color(0, 10, 10, 10, 255) -- SUBMENU NAME BG
        -- draw.rect_filled(
        --     bg.lu.x, 
        --     bg.lu.y - config.optionHeight, 
        --     bg.rd.x, 
        --     bg.lu.y
        -- )
        local path = ""
        -- for _, submenu in ipairs(config.path) do
        --     path = path .. submenu.name .. "/"
        -- end
        path = tostring(config.path[#config.path].name)
        draw.set_color(0, 255, 255, 255, 255) -- SUBMENU NAME TEXT
        draw.text(
            bg.lu.x + 10,
            (bg.lu.y - config.optionHeight - (bg.lu.y - config.optionHeight - bg.lu.y)/2) - draw.get_text_size_y(path)/2,
            path
        )

        draw.texture(
            materials.header,
            bg.lu.x,
            -- bg.lu.y - config.optionHeight - 90,
            bg.lu.y - 90 - config.optionHeight,
            config.width,
            90
        )

        if submenu.isDynamic then
            submenu.options = {}
            for i = 1, submenu.indexGetter() do
                submenu.options[i] = submenu.optionGetter(i)
            end
        end

        for i, _ in ipairs(submenu.options) do -- RENDERING OPTIONS NAMES
            local option = i + submenu.scrollOffset
            if i > config.maxOptions then
                break
            end
            local data = submenu.options[option]
            local lu = {
                x = bg.lu.x, 
                y = bg.lu.y + config.optionHeight*(i - 1),
            }
            local rd = {
                x = bg.rd.x, 
                y = bg.lu.y + config.optionHeight*i
            }

            if submenu.selectedOption == option then
                draw.set_color(0, 255, 255, 255, 255) -- SELECTED OPTION
                local lu = {
                    x = bg.lu.x, 
                    y = bg.lu.y + config.optionHeight*(submenu.selectedOption - 1),
                }
                local rd = {
                    x = bg.rd.x, 
                    y = bg.lu.y + config.optionHeight*submenu.selectedOption
                }
                if (submenu.selectedOption > config.maxOptions) and (#submenu.options > config.maxOptions) then
                    lu = {
                        x = bg.lu.x, 
                        y = bg.lu.y + config.optionHeight*(config.maxOptions - 1),
                    }
                    rd = {
                        x = bg.rd.x, 
                        y = bg.lu.y + config.optionHeight*config.maxOptions
                    }
                end
                if config.enabelSmoothScroller then
                    if (submenu.selectedOption == #submenu.options and not config.isActionDown) 
                    or (submenu.selectedOption == 1 and config.isActionDown) 
                    or (i == config.maxOptions and not config.isActionDown)
                    then
                        --config.test = config.optionHeight
                    else
                        if config.test <= config.optionHeight and config.isActionDown then
                            if math.abs(config.test - config.optionHeight) >= config.scrollerSmooth then
                                config.test = config.test + config.scrollerSmooth
                            else
                                config.test = config.test + (config.optionHeight - config.test)
                            end
                            lu.y = lu.y - config.optionHeight + config.test
                        elseif config.test <= config.optionHeight and not config.isActionDown then
                            if math.abs(config.test - config.optionHeight) >= config.scrollerSmooth then
                                config.test = config.test + config.scrollerSmooth
                            else
                                config.test = config.test + (config.optionHeight - config.test)
                            end
                            lu.y = lu.y + config.optionHeight - config.test
                        else
                            config.test = 0.0
                        end
                    end
                end
                -- draw.rect_filled(
                --     lu.x,
                --     lu.y,
                --     rd.x,
                --     rd.y
                -- )
                draw.texture(
                    materials.selected,
                    lu.x, 
                    lu.y,
                    config.width,
                    config.optionHeight
                )

                local hint = tostring(submenu.options[submenu.selectedOption].hint)
                if hint ~= "" then
                    local y = bg.rd.y + config.optionHeight + 10
                    draw.texture(
                        materials.hintBox,
                        bg.lu.x,
                        y,
                        config.width,
                        config.optionHeight
                    )
                    draw.text(
                        bg.lu.x + 10,
                        (y + config.optionHeight - config.optionHeight/2) - draw.get_text_size_y(hint)/2,
                        hint
                    )
                end

            end
            if not data then return end
            if data.type == OPTIONS.SEPARATOR then
                local name = data.name

                -- draw.set_color(0, 51, 51, 51, 255)
                -- draw.rect_filled(
                --     lu.x, lu.y, rd.x, rd.y
                -- )
                
                draw.set_color(0, 255, 255, 255, 255)
                draw.text(
                    (rd.x - (rd.x - lu.x)/2) - draw.get_text_size_x(name)/2,
                    (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(name)/2,
                    name
                )
                draw.line(
                    lu.x + 10,
                    lu.y + (rd.y - lu.y)/2,
                    (rd.x - (rd.x - lu.x)/2) - draw.get_text_size_x(name)/2 - 10,
                    lu.y + (rd.y - lu.y)/2
                )
                draw.line(
                    (rd.x - (rd.x - lu.x)/2) + draw.get_text_size_x(name)/2 + 10,
                    lu.y + (rd.y - lu.y)/2,
                    rd.x - 10,
                    lu.y + (rd.y - lu.y)/2
                )
            elseif data.type == OPTIONS.STATE_BAR then
                -- draw.set_color(0, 51, 51, 51, 255)
                -- draw.rect_filled(
                --     lu.x, lu.y, rd.x, rd.y
                -- )
                local name = tostring(data.name)
                local value = tostring(data.getter())
                draw.set_color(0, 255, 255, 255, 255)
                draw.text(
                    lu.x + 10,
                    (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(name)/2,
                    name
                )
                draw.text(
                    rd.x - draw.get_text_size_x(value) - 10,
                    (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(value)/2,
                    value
                )
            else            
                -- if option == submenu.selectedOption then
                --     local name = tostring(data.name) -- TEXT RENDERING
 
                --     draw.set_color(0, 0, 0, 0, 255)

                --     draw.text(
                --         lu.x + 10,
                --         (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(name)/2,
                --         name
                --     )
                -- else
                -- end
                local name = tostring(data.name)
                draw.set_color(0, 255, 255, 255, 255)
                draw.text(
                    lu.x + 10,
                    (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(name)/2,
                    name
                )
                config.iconsSize = 40.0
                local symbol = nil
                local material = nil
                if data.type == OPTIONS.CLICK then
                    -- do smth
                elseif data.type == OPTIONS.BOOL then
                    material = materials.toggleOff
                    if data.value then material = materials.toggleOn end
                elseif data.type == OPTIONS.NUM then
                    symbol = string.format("<%i>", data.value)
                elseif data.type == OPTIONS.FLOAT then
                    symbol = string.format("<%s>", data.value + .0)
                elseif data.type == OPTIONS.CHOOSE then
                    symbol = string.format("<%s>", data.table[data.value])
                elseif data.type == OPTIONS.SUB then
                    material = materials.sub
                elseif data.type == OPTIONS.TEXT_INPUT then
                    if data.value == "" then
                        symbol = "[Empty]"
                    else
                        symbol = string.format("[%s]", data.value)
                    end
                end

                if material then
                    draw.texture(
                        material,
                        rd.x - config.iconsSize,
                        (rd.y - (rd.y - lu.y)/2) -config.iconsSize/2,
                        config.iconsSize,
                        config.iconsSize
                    )
                elseif symbol then
                    draw.text(
                        rd.x - draw.get_text_size_x(symbol) - 10,
                        (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(symbol)/2,
                        symbol
                    )
                end
            end

        end
    end
end)