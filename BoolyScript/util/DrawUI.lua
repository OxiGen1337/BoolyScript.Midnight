local paths = require("BoolyScript/globals/paths")
require("BoolyScript/globals/stuff")
local parse = require("BoolyScript/util/parse")
local fs = require("BoolyScript/util/file_system")
local json = require("BoolyScript/modules/JSON")
require("BoolyScript/system/events_listener")

local config = {
    width = 325.0,
    height = 500.0,
    optionHeight = 30.0,
    selectedOption = 1,
    maxOptions = 12,
    isInputBoxDisplayed = false,
    inputBoxText = "",
    inputBoxCallback = nil,
    inputBoxHeight = 70,
    inputBoxWidth = 150,
    isOpened = true,
    path = {},
    inputDelay = 0.3,
    test = 0.0,
    scrollerSmooth = 2.5,
    enabelSmoothScroller = false,
    renderedNotifies = 0,
    notifyHeight = 60,
    notifyWidth = 200,
    notifyTime = 5.0,
    lastNotifyOffset = 0,
    notifies = {},
    isClickSoundEnabled = true,
    footerArrowsSize = 28.0,
    drawSlider = true,
    showPath = true,
    drawKeysPanel = true,
    shiftState = false,
    headerHeight = 90,
    localization = nil,
}


config.offset_x = draw.get_window_width() - 100 - config.width
config.offset_y = 200

DrawUI = {}
DrawUI.getSelectedOption = function ()
    return config.selectedOption
end

DrawUI.isOpened = function ()
    return config.isOpened
end

DrawUI.dbg = {
    fps = 0,
    lastSec = math.ceil(os.clock()),
    frameCount = 0,
}


local arrowsControls = {
    open = 119,
    down = 40,
    up = 38, 
    left = 37,
    right = 39,
    enter = 13,
    back = 8,
}

local numpadControls = {
    open = 106,
    down = 98,
    up = 104, 
    left = 100,
    right = 102,
    enter = 101,
    back = 96,
}

local controls = arrowsControls

Stuff.controlsState = {
    [controls.up] = {false, nil, nil},
    [controls.down] = {false, nil, nil},
    [controls.back] = {false, nil, nil},
    [controls.enter] = {false, nil, nil},
    [controls.left] = {false, nil, nil},
    [controls.right] = {false, nil, nil},
}

local keyboardKeys = {
-- key = {lower, upper}
    [48] =  {"0", ")"},
    [49] =  {"1", "!"},
    [50] =  {"2", "@"},
    [51] =  {"3", "#"},
    [52] =  {"4", "$"},
    [53] =  {"5", "%"},
    [54] =  {"6", "^"},
    [55] =  {"7", "&"},
    [56] =  {"8", "*"},
    [57] =  {"9", "("},
    [65] =  {"a", "A"},
    [66] =  {"b", "B"},
    [67] =  {"c", "C"},
    [68] =  {"d", "D"},
    [69] =  {"e", "E"},
    [70] =  {"f", "F"},
    [71] =  {"g", "G"},
    [72] =  {"h", "H"},
    [73] =  {"i", "I"},
    [74] =  {"j", "J"},
    [75] =  {"k", "K"},
    [76] =  {"l", "L"},
    [77] =  {"m", "M"},
    [78] =  {"n", "N"},
    [79] =  {"o", "O"},
    [80] =  {"p", "P"},
    [81] =  {"q", "Q"},
    [82] =  {"r", "R"},
    [83] =  {"s", "S"},
    [84] =  {"t", "T"},
    [85] =  {"u", "U"},
    [86] =  {"v", "V"},
    [87] =  {"w", "W"},
    [88] =  {"x", "X"},
    [89] =  {"y", "Y"},
    [90] =  {"z", "Z"},
    [96] =  {"0", "0"},
    [97] =  {"1", "1"},
    [98] =  {"2", "2"},
    [99] =  {"3", "3"},
    [100] = {"4", "4"},
    [101] = {"5", "5"},
    [102] = {"6", "6"},
    [103] = {"7", "7"},
    [104] = {"8", "8"},
    [105] = {"9", "9"},
    [106] = {"*", "*"},
    [107] = {"+", "+"},
    [109] = {"-", "-"},
    [110] = {".", "."},
    [111] = {"/", "/"},
    [186] = {";", ":"},
    [187] = {"=", "+"},
    [188] = {",", "<"},
    [189] = {"-", "_"},
    [190] = {".", ">"},
    [191] = {"/", "?"},
    [192] = {"`", "~"},
    [219] = {"[", "{"},
    [229] = {"\\", "|"},
    [221] = {"]", "}"},
    [222] = {"\\", "\""},
    [32] = {" ", " "},
}

function getKeyFromID(key, isShiftDown)
    if keyboardKeys[key] then
        if isShiftDown then return keyboardKeys[key][2] end
        return keyboardKeys[key][1]
    end
    return ""
end

local materials = {}

materials.header = draw.create_texture_from_file(paths.files.imgs.header)
-- materials.bg = draw.create_texture_from_file(paths.files.imgs.bg)
-- materials.selected = draw.create_texture_from_file(paths.files.imgs.selected)
-- materials.footer = draw.create_texture_from_file(paths.files.imgs.footer)
-- materials.hintBox = draw.create_texture_from_file(paths.files.imgs.hintBox)
materials.footerArrows = draw.create_texture_from_file(paths.files.imgs.footerArrows)
materials.toggleOn = draw.create_texture_from_file(paths.files.imgs.toggleOn)
materials.toggleOff = draw.create_texture_from_file(paths.files.imgs.toggleOff)
materials.sub = draw.create_texture_from_file(paths.files.imgs.sub)
materials.cursor = draw.create_texture_from_file(paths.files.imgs.cursor)

-- materials.font = nil

-- draw.create_font("Tahoma", 17.0, function(f)
-- 	materials.font = f
-- end)


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
    RAW_INPUT = 10,
    DYN_CHOOSE = 11,
}

local submenus = {}
local options = {}
local searchOptions = {}

GET_OPTIONS =  function ()
    return options
end

Submenu = {
    ID = nil,
    name = nil,
    hash = "",
    isDynamic = false,
    options = {},
    selectedOption = 1,
    prevOption = 1,
    --for dynamic submenus
    getter = function ()
        
    end,
    getSubmenus = function ()
        return submenus
    end,
    translationIgnore = false,
    sliderPos = nil,
    scrollerPos = nil,
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
    execOnSelection = true,
    getter = nil,
    hint = "",
    default = nil,
    configIgnore = false,
    translationIgnore = false,
    tags = {},
    isHotkeyable = false,
    hotkey = nil,
    onDelete = nil,
}
Option.__index = Option

NotifyService = {}
NotifyService.__index = NotifyService

function NotifyService:notify(title_s, text_s, r, g, b)
    title_s, text_s = tostring(title_s), tostring(text_s)
    if not title_s then
        return(log.error("NotifyService", string.format("Wrong title value type | Received '%s'; expected 'string'/'num'.", type(title_s))))
    elseif not text_s then 
        return(log.error("NotifyService", string.format("Wrong text value type | Received '%s'; expected 'string'/'num'.", type(text_s))))
    end
    local notifyHash = "Notify_Render_" .. os.clock() .. math.random(1337)
    local titleTextSize = draw.get_text_size(title_s)
    local textSize = draw.get_text_size(text_s)
    local notifyHeight = 10 + titleTextSize.y + 5 + textSize.y + 10
    local notifyWidth = 10 + math.max(titleTextSize.x, textSize.x) + 10
    local yOffset = 20.0
    for _, height in pairs(config.notifies) do
        yOffset = yOffset + height + 10
    end
    config.renderedNotifies = config.renderedNotifies + 1
    config.notifies[notifyHash] = notifyHeight
    local notifyTime = os.clock() + config.notifyTime
    local notifyStep = 5
    local alphaStep = math.ceil(255 / (notifyWidth / notifyStep))
    local alpha = 0
    local finalLeftPos = {
        x = draw.get_window_width() - 20,
        y = yOffset + 20 + notifyHeight
    }
    local finalRightPos = {
        x = draw.get_window_width() + notifyWidth,
        y = yOffset + 20 + notifyHeight
    }
    local currentPos = finalRightPos
    local endPos = finalLeftPos
    listener.register(notifyHash, GET_EVENTS_LIST().OnFrame, function ()
        if os.clock() >= notifyTime then
            endPos = {
                x = draw.get_window_width() + notifyWidth,
                y = yOffset + 20 + notifyHeight
            }
            if currentPos.x == endPos.x then
                listener.remove(notifyHash, GET_EVENTS_LIST().OnFrame)
                config.renderedNotifies = config.renderedNotifies - 1
                if config.renderedNotifies == 0 then
                    config.notifies = {}
                end
            end
        end
        if currentPos.x < endPos.x then -- RIGHT
            currentPos.x = math.min(endPos.x, currentPos.x + notifyStep)
            alpha = math.max(0, alpha - alphaStep)
        elseif currentPos.x > endPos.x then -- LEFT
            currentPos.x = math.max(endPos.x, currentPos.x - notifyStep)
            alpha = math.min(255, alpha + alphaStep)
        end
        local leftUpper = {
            x = currentPos.x - notifyWidth,
            y = currentPos.y - notifyHeight,
        }
        local rightDown = currentPos
        draw.set_color(0, 25, 25, 25, alpha)
        draw.set_rounding(5)
        draw.rect_filled(
            leftUpper.x,
            leftUpper.y,
            rightDown.x,
            rightDown.y
        )
        draw.set_color(0, r, g, b, alpha)
        draw.set_rounding(50)
        draw.set_flags(5)
        draw.rect_filled(
            leftUpper.x,
            leftUpper.y,
            leftUpper.x + 4,
            rightDown.y
        )
        draw.set_rounding(0)
        draw.set_flags(0)
        draw.set_color(0, r, g, b, alpha)
        draw.text(
            leftUpper.x + 10,
            leftUpper.y + 10,
            title_s
        )
        draw.set_color(0, r, g, b, alpha)
        draw.set_rounding(5)
        draw.set_color(0, 255, 255, 255, alpha)
        draw.text(
            leftUpper.x + 10,
            leftUpper.y + titleTextSize.y + 10 + 5,
            text_s
        )
        draw.set_rounding(0)
    end)
end

InputService = {}
InputService.__index = InputService

function InputService:displayInputBox(name_s, type_s, callback_f)
    if config.isInputBoxDisplayed then return end
    local settings = {
        height = 200,
        width = 350,
        textAreaHeight = 40,
        buttonHeight = 35,
        focusedMargin = 2,
        cursorAlphaTarget = 0,
        cursorTime = os.clock(),
        cursorCurAlpha = 255,
    }
    config.isInputBoxDisplayed = true
    local title = ""
    if type_s == "text" then
        title = name_s or "Please, enter a new value."
    elseif type_s == "hotkey" then
        title = "Press any button to set a hotkey."
    end
    local mousePos = Vector2()
    local enteredText = ""
    local corners = {}
        corners.background = {
            leftUpper = {
                x = draw.get_window_width()/2 - settings.width/2,
                y = draw.get_window_height()/2 - settings.height/2,
            },
            rightDown = {
                x = draw.get_window_width()/2 + settings.width/2,
                y = draw.get_window_height()/2 + settings.height/2,
            },
        }
        corners.textArea = {
            leftUpper = {
                x = corners.background.leftUpper.x + 30,
                y = corners.background.leftUpper.y + settings.height/2 - settings.textAreaHeight/2,
            },
            rightDown = {
                x = corners.background.rightDown.x - 30,
                y = corners.background.rightDown.y - settings.height/2 + settings.textAreaHeight/2,
            }       
        }
        corners.title = {
            leftUpper = {
                x = corners.background.leftUpper.x + settings.width/2 - draw.get_text_size_x(title)/2,
                y = corners.background.leftUpper.y + (corners.textArea.leftUpper.y - corners.background.leftUpper.y)/2 - draw.get_text_size_y(title)/2,
            },
            rightDown = {
                x = corners.background.rightDown.x - settings.width/2 + draw.get_text_size_x(title)/2,
                y = corners.background.leftUpper.y + (corners.textArea.leftUpper.y - corners.background.leftUpper.y)/2 + draw.get_text_size_y(title)/2,
            }
        }
        local buttonWidth = (corners.background.rightDown.x - corners.background.leftUpper.x - 30 - 20 - 30) / 2
        corners.button1 = {
            leftUpper = {
                x = corners.background.leftUpper.x + 30,
                y = corners.textArea.rightDown.y + (corners.background.rightDown.y - corners.textArea.rightDown.y)/2 - settings.buttonHeight/2,
            },
            rightDown = {
                x = corners.background.leftUpper.x + 30 + buttonWidth,
                y = corners.textArea.rightDown.y + (corners.background.rightDown.y - corners.textArea.rightDown.y)/2 + settings.buttonHeight/2,
            }
        }
        corners.button2 = {
            leftUpper = {
                x = corners.background.rightDown.x - 30 - buttonWidth,
                y = corners.textArea.rightDown.y + (corners.background.rightDown.y - corners.textArea.rightDown.y)/2 - settings.buttonHeight/2,
            },
            rightDown = {
                x = corners.background.rightDown.x - 30,
                y = corners.textArea.rightDown.y + (corners.background.rightDown.y - corners.textArea.rightDown.y)/2 + settings.buttonHeight/2,
            }
        }
    listener.register("DrawUI_InputBox", GET_EVENTS_LIST().OnFrame, function ()  
        utils.get_mouse_pos(mousePos)
        local isFocusedOn = {
            button1 = features.isPositionInArea(corners.button1.leftUpper, corners.button1.rightDown, mousePos),
            button2 = features.isPositionInArea(corners.button2.leftUpper, corners.button2.rightDown, mousePos),
        }
        draw.set_color(0, 14, 17, 19, 255)
        draw.set_rounding(10)
        draw.rect_filled(
            corners.background.leftUpper.x,
            corners.background.leftUpper.y,
            corners.background.rightDown.x,
            corners.background.rightDown.y
        )
        draw.set_rounding(0)

        draw.set_color(0, 255, 255, 255, 255)
        draw.text(
            corners.title.leftUpper.x,
            corners.title.leftUpper.y,
            title
        )

        draw.set_color(0, 34, 41, 47, 255)
        draw.set_rounding(10)
        draw.rect_filled(
            corners.textArea.leftUpper.x,
            corners.textArea.leftUpper.y,
            corners.textArea.rightDown.x,
            corners.textArea.rightDown.y
        )
        local textColor = {0, 255, 255, 255, 255}
        local renderedText = ""
        if type_s == "text" then
            if enteredText ~= "" then
                renderedText = enteredText
            else
                renderedText = "Start typing..."
                textColor = {0, 150, 150, 150, 255}
            end 
            if os.clock() - settings.cursorTime >= 0.5 then
                settings.cursorAlphaTarget = settings.cursorAlphaTarget == 255 and 0 or 255
                settings.cursorTime = os.clock()
            end
            if settings.cursorCurAlpha < settings.cursorAlphaTarget then 
                settings.cursorCurAlpha = math.min(255, settings.cursorCurAlpha + 20)
            elseif settings.cursorCurAlpha > settings.cursorAlphaTarget then
                settings.cursorCurAlpha = math.max(0, settings.cursorCurAlpha - 20)
            end
            draw.set_color(0, 200, 200, 200, settings.cursorCurAlpha)
            draw.set_thickness(2)
            draw.line(
                corners.textArea.leftUpper.x + 10 + draw.get_text_size_x(renderedText) + 2,
                corners.textArea.leftUpper.y + settings.textAreaHeight/2 - draw.get_text_size_y(renderedText)/2,
                corners.textArea.leftUpper.x + 10 + draw.get_text_size_x(renderedText) + 2,
                corners.textArea.rightDown.y - settings.textAreaHeight/2 + draw.get_text_size_y(renderedText)/2
            )
            draw.set_thickness(1)
        else
            if enteredText ~= "" then
                renderedText = "Hotkey -> [" .. enteredText .. "]"
            else
                renderedText = "Waiting for a key..."
                draw.set_color(0, 150, 150, 150, 255)
            end 
        end
        draw.set_color(table.unpack(textColor))
        draw.text(
            corners.textArea.leftUpper.x + 10,
            corners.textArea.leftUpper.y + settings.textAreaHeight/2 - draw.get_text_size_y(renderedText)/2,
            renderedText
        )
        draw.set_color(0, 34, 41, 47, 255)
        if isFocusedOn.button1 then
            draw.set_color(0, 83, 180, 223, 255)
        end
        draw.rect_filled(
            corners.button1.leftUpper.x,
            corners.button1.leftUpper.y - (isFocusedOn.button1 and settings.focusedMargin or 0),
            corners.button1.rightDown.x,
            corners.button1.rightDown.y + (isFocusedOn.button1 and settings.focusedMargin or 0)
        )
        draw.set_color(0, 34, 41, 47, 255)
        if isFocusedOn.button2 then
            draw.set_color(0, 83, 180, 223, 255)
        end
        draw.rect_filled(
            corners.button2.leftUpper.x,
            corners.button2.leftUpper.y - (isFocusedOn.button2 and settings.focusedMargin or 0),
            corners.button2.rightDown.x,
            corners.button2.rightDown.y + (isFocusedOn.button2 and settings.focusedMargin or 0)
        )
        draw.set_rounding(0)
        draw.set_color(0, 255, 255, 255, 255)
        if isFocusedOn.button1 then
            draw.set_color(0, 0, 0, 0, 255)
        end
        draw.text(
            corners.button1.leftUpper.x + buttonWidth/2 - draw.get_text_size_x("Cancel")/2,
            corners.button1.leftUpper.y + settings.buttonHeight/2 - draw.get_text_size_y("Cancel")/2,
            "Cancel"
        )
        draw.set_color(0, 255, 255, 255, 255)
        if isFocusedOn.button2 then
            draw.set_color(0, 0, 0, 0, 255)
        end
        draw.text(
            corners.button2.leftUpper.x + buttonWidth/2 - draw.get_text_size_x("OK")/2,
            corners.button2.leftUpper.y + settings.buttonHeight/2 - draw.get_text_size_y("OK")/2,
            "OK"
        )
        draw.texture(
            materials.cursor,
            mousePos.x,
            mousePos.y
        )
    end)
    local function finishInput(doReturnValue_b)
        if callback_f and doReturnValue_b then callback_f(enteredText) end
        listener.remove("DrawUI_InputBox", GET_EVENTS_LIST().OnFrame)
        listener.remove("DrawUI_InputBoxMouse", GET_EVENTS_LIST().OnKeyPressed)
        listener.remove("DrawUI_InputBoxKeyboard", GET_EVENTS_LIST().OnKeyPressed)
        task.createTask("DrawUI_InputBox_DisableControlsFinish", 0.2, 2, function (cnt)
            if cnt ~= 2 then return end
            config.isInputBoxDisplayed = false
        end)
    end
    listener.register("DrawUI_InputBoxMouse", GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
        if key ~= gui.mouseButtons.Left then return end
        if isDown then return end
        if not features.isPositionInArea(corners.button2.leftUpper, corners.button2.rightDown, mousePos) and not features.isPositionInArea(corners.button1.leftUpper, corners.button1.rightDown, mousePos) then return end
        if features.isPositionInArea(corners.button2.leftUpper, corners.button2.rightDown, mousePos) then
            finishInput(true)
            return
        end
        finishInput(false)
    end)
    local startTime = os.clock()
    listener.register("DrawUI_InputBoxKeyboard", GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
        if os.clock() - startTime < 0.1 then return end
        if not isDown then return end
        if key == gui.virualKeys["Enter"] then
            return finishInput(true)
        end
        if key == gui.virualKeys["Esc"] then
            return finishInput(false)
        end
        if type_s == "text" then
            if key == gui.virualKeys.Backspace then enteredText = enteredText:sub(1, -2) return end
            if draw.get_text_size_x(enteredText) >= corners.textArea.rightDown.x - corners.textArea.leftUpper.x - 10 - 10 and getKeyFromID(key, config.shiftState) ~= "" then
                return notify.warning("Input service", "Too many symbols!")
            end
            local value = getKeyFromID(key, config.shiftState)
            if value == "" then return end
            enteredText = enteredText .. value
        else
            local value = features.getVirtualKeyViaID(key)
            if not value then return end
            enteredText = value
        end
    end)
end

HotkeyService = {}
HotkeyService.runtimeHotkeys = {}

function HotkeyService.loadHotkeys()
    HotkeyService.runtimeHotkeys = {}
    if not filesys.doesFileExist(paths.files.hotkeys) then return end
    parse.json(paths.files.hotkeys, function (content)
        for _, option in ipairs(options) do
            option.hotkey = nil
            for key, hashes in pairs(content) do
                for _, hash in ipairs(hashes) do
                    if hash == option.hash then
                        if not HotkeyService.runtimeHotkeys[key] then HotkeyService.runtimeHotkeys[key] = {} end
                        table.insert(HotkeyService.runtimeHotkeys[key], option)
                        option.hotkey = key
                    end
                end
            end
        end
    end)
    log.default("Hotkey service", "Hotkeys have been reloaded.")
end

function HotkeyService.registerHotkey(key_n, optionHash_s)
    local hotkeys = {}
    local keyName = features.getVirtualKeyViaID(key_n)
    if filesys.doesFileExist(paths.files.hotkeys) then
        parse.json(paths.files.hotkeys, function (content)
            local out = content
            if not out[keyName] then
                out[keyName] = {}
            else
                for key, hashes in pairs(out) do
                    for index, hash in ipairs(hashes) do
                        if optionHash_s == hash then
                            table.remove(out[features.getVirtualKeyViaID(key)], index)
                            log.default("Hotkey service", "Hotkey has been overwritten.")
                        end
                    end
                end
            end
            hotkeys = out
        end)
    end

    if not hotkeys[keyName] then hotkeys[keyName] = {} end
    table.insert(hotkeys[keyName], optionHash_s)
    local file = io.open(paths.files.hotkeys, "w+")
    local content = json:encode_pretty(hotkeys)
    file:write(content)
    file:close()

    HotkeyService.loadHotkeys()

    notify.success("Hotkey service", "Successfully registered a hotkey.")
end

function HotkeyService.removeHotkey(optionHash_s)
    local hotkeys = {}
    if filesys.doesFileExist(paths.files.hotkeys) then 
        parse.json(paths.files.hotkeys, function (content)
            for key, hashes in pairs(content) do
                for _, hash in ipairs(hashes) do
                    if optionHash_s ~= hash then
                        if not hotkeys[key] then hotkeys[key] = {} end
                        table.insert(hotkeys[key], hash)
                    end
                end
            end
        end)
    end

    local file = io.open(paths.files.hotkeys, "w+")
    local content = json:encode_pretty(hotkeys)
    file:write(content)
    file:close()

    HotkeyService.loadHotkeys()

    notify.success("Hotkey service", "Successfully removed a hotkey.")
end

listener.register("DrawUI_Hotkeys", GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
    if not isDown then return end
    if config.isOpened then
        if key == gui.virualKeys.F11 then        
            local submenu = config.path[#config.path]
            local option = submenu.options[submenu.selectedOption]
            if not option.hotkey then
                InputService:displayInputBox(nil, "hotkey", function (key_s)
                    HotkeyService.registerHotkey(gui.virualKeys[key_s], option.hash)
                end)
            else
                HotkeyService.removeHotkey(option.hash)
            end
        end
    end
    if Stuff.isTextChatActive then return end
    if config.isInputBoxDisplayed then return end
    local keyName = features.getVirtualKeyViaID(key)
    if not HotkeyService.runtimeHotkeys[keyName] then return end
    for _, option in ipairs(HotkeyService.runtimeHotkeys[keyName]) do
        if option.type == OPTIONS.BOOL then
            option:setValue(not option.value)
            local strState = option:getValue() and "Enabled" or "Disabled"
            notify.default("Hotkeys", string.format("%s \'%s\' option.", strState, option:getName()))
        else
            option:setValue(option.value)
            notify.default("Hotkeys", string.format("Executed \'%s\' option.", option:getName()))
        end
    end
end)

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
    if config.path[1] then log.error("DrawUI", "Main submenu already exists. You can't add multiple main submenus.") return end
    config.path[1] = submenu
    return submenu
end

function Submenu.add_dynamic_submenu(name_s, hash_s, getter_f)
    local submenu = setmetatable({}, Submenu)
    submenu.ID = #Submenu.getSubmenus() + 1
    submenu.name = name_s
    submenu.hash = hash_s
    submenu.isDynamic = true
    submenu.getter = getter_f
    submenu.options = {}
    table.insert(submenus, submenu)
    return submenu
end

function Option.new(submenu_mt, name_s, hash_s, type_n, value_n, callback_f)
    local option = setmetatable({}, Option)
    option.ID = #submenu_mt.options + 1
    option.name = name_s
    option.type = type_n
    option.hash = hash_s
    option.callback = function (...)
        local args = {...}
        task.executeAsScript(hash_s .. tostring(os.clock()) .. tostring(math.random(1337)), function ()
            if callback_f then callback_f(table.unpack(args)) end
        end)
    end
    option.value = value_n
    option.submenu = submenu_mt
    table.insert(submenu_mt.options, option)
    table.insert(options, option)
    searchOptions[hash_s] = option
    return option
end

function Submenu:setActive(state)
    local function getClickableOption(self, selectedOption)
        if #self.options < 2 then return 1 end
        if self.isDynamic then return selectedOption end
        if selectedOption > #self.options then 
            return getClickableOption(self, 1)
        end
        if (self.options[selectedOption].type ~= OPTIONS.SEPARATOR) and (self.options[selectedOption].type ~= OPTIONS.STATE_BAR) then
            return selectedOption
        else
            return getClickableOption(self, selectedOption + 1)
        end
    end
    if state then
        table.insert(config.path, self)
    else
        if config.path[#config.path] == self then
            table.remove(config.path)
        end
    end
    config.path[#config.path].selectedOption = getClickableOption(config.path[#config.path], config.path[#config.path].selectedOption)
    return self
end

function Submenu:add_sub_option(name_s, hash_s, submenu_mt, on_opened_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.SUB, nil, function ()
        submenu_mt:setActive(true)
        if on_opened_f then on_opened_f() end
    end)
    option:setConfigIgnore()
    return option
end


function Submenu:isOpened()
    return config.path[#config.path] == self
end

function Submenu:add_click_option(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.CLICK, nil, callback_f)
    option:setConfigIgnore()
    option:setHotkeyable(true)
    return option
end

function Submenu:add_bool_option(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.BOOL, false, callback_f)
    option:setHotkeyable(true)
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
    option:setHotkeyable(true)
    return option
end

function Submenu:add_float_option(name_s, hash_s, min_n, max_n, step_n, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.FLOAT, 0.0, callback_f)
    option.minValue = min_n
    option.maxValue = max_n
    option.step = step_n
    option:setHotkeyable(true)
    return option
end

function Submenu:add_choose_option(name_s, hash_s, execOnSelection_b, table_t, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.CHOOSE, 1, callback_f)
    option.execOnSelection = execOnSelection_b
    option.table = table_t
    option:setHotkeyable(true)
    return option
end

function Submenu:add_separator(name_s, hash_s)
    local option = Option.new(self, name_s, hash_s, OPTIONS.SEPARATOR, nil, nil)
    option:setConfigIgnore()
    return option
end

function Submenu:add_state_bar(name_s, hash_s, getter_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.STATE_BAR, nil, nil)
    option.getter = getter_f
    option:setConfigIgnore()
    return option
end

function Submenu:add_text_input(name_s, hash_s, callback_f)
    local option = Option.new(self, name_s, hash_s, OPTIONS.TEXT_INPUT, nil, callback_f)
    option.value = ""
    return option
end

-- function Submenu:add_dynamic_choose(name_s, hash_s, table_getter_f, callback_f)
--     local option = Option.new(self, name_s, hash_s, OPTIONS.DYN_CHOOSE, nil, callback_f)
--     option.getter = table_getter_f
--     option:setConfigIgnore()
--     return option
-- end

-- function Submenu:add_raw_input(name_s, hash_s, callback_f)
--     local option = Option.new(self, name_s, hash_s, OPTIONS.RAW_INPUT, nil, callback_f)
--     option.value = nil
--     return option
-- end


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


function Submenu:setTranslationIgnore()
    self.translationIgnore = true
    return self
end

function Submenu:remove()
    if not self then return end
    if config.path[#config.path] == self then self:setActive(false) end
    for ID, sub in ipairs(submenus) do
        if sub == self then
            table.remove(submenus, ID)
            break
        end
    end
    self = nil
    return nil
end

-- OPTION METHODS

function Option:getValue()
    return self.value
end

function Option:setValue(value, ignoreCallback_b)
    if not self then return end
    if self.type == OPTIONS.NUM or self.type == OPTIONS.FLOAT then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif (self.type == OPTIONS.CHOOSE and type(value) == "number" ) then
        if value <= #self.table then
            self.value = value
        else
            self.value = 1
        end
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif (self.type == OPTIONS.BOOL and type(value) == "boolean") then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif (self.type == OPTIONS.CLICK) then
        if self.callback and not ignoreCallback_b then self.callback(self) end
        return self
    elseif (self.type == OPTIONS.TEXT_INPUT and type(value) == "string") then
        self.value = value
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    end
    self.value = value
    return self
end

function Option:reset(ignoreCallback_b)
    if self.type == OPTIONS.NUM or self.type == OPTIONS.FLOAT then
        self.value = self.minValue
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif self.type == OPTIONS.CHOOSE then
        self.value = 1
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif self.type == OPTIONS.BOOL then
        self.value = false
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
        return self
    elseif self.type == OPTIONS.TEXT_INPUT then
        self.value = ""
        if self.callback and not ignoreCallback_b then self.callback(self.value, self) end
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

function Option:setConfigIgnore()
    self.configIgnore = true
    return self
end

function Option:setTranslationIgnore()
    self.translationIgnore = true
    return self
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
    local status = false
    if not self then return false end
    local newOptions = {}
    for ID, opt in ipairs(self.submenu.options) do
        if opt ~= self then
            table.insert(newOptions, opt)
        else
            status = true
        end
    end
    self.submenu.options = newOptions
    if not status then
        return false, log.error("Options", "Failed to remove option.")
    end
    return true
end

function Option:addTag(tag_t)
    if not (type(tag_t) == "table") then return end
    self.tags = {tag_t}
    return self
end

function Option:setTags(tags_t)
    if not (type(tags_t) == "table") then return end
    self.tags = tags_t
    return self
end

function Option:setHotkeyable(state)
    self.isHotkeyable = state
    return self
end

function Option:setDeletable(callback_f)
    self.onDelete = callback_f or function () end
    return self
end

Configs = {}
Configs.saveConfig = function ()
    local out = {}
    for _, option in ipairs(options) do
        if not option.configIgnore then
            out[option.hash] = option.value
        end
    end
    local file = io.open(paths.files.config, "w+")
    if not file then return end
    file:write(json:encode_pretty(out))
    file:close()
    log.success("Settings", "Config has been updated.")
    notify.success("Settings", "Config has been updated.")
end

Configs.loadConfig = function ()
    if fs.doesFileExist(paths.files.config) then
        parse.json(paths.files.config, function (config)        
            for _, option in ipairs(options) do
                if not option.configIgnore then
                    local value = config[option.hash]
                    if (value ~= option.value) then
                        Option.setValue(option, value, not option.execOnSelection)
                    end
                end
            end
            log.success("Settings", "Config has been loaded.")
            notify.success("Settings", "Config has been loaded.")
        end)
    else
        log.warning("Settings", "Config doesn't exist.")
    end
end

local function playClickSound()
    if not config.isClickSoundEnabled then return end
    task.createTask("DrawUI_PlayClickSound_" .. os.clock(), 0.0, 1, function ()
        AUDIO.PLAY_SOUND_FRONTEND(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end)
end

task.createTask("DrawUI_ControlsCheck", 0.0, nil, function ()
    if not config.isInputBoxDisplayed then return end
    PAD.DISABLE_ALL_CONTROL_ACTIONS(2)
end)

local function onControl(key, isDown, ignoreControlsState)
    if Stuff.controlsState[key] and not ignoreControlsState then
        Stuff.controlsState[key][1] = isDown
        Stuff.controlsState[key][2] = os.clock()
        Stuff.controlsState[key][3] = os.clock() + config.inputDelay
    end
    if key == 160 or key == 161 then config.shiftState = isDown end
    if isDown then
        if key == controls.open then
            config.isOpened = not config.isOpened
        end
    end
    if not config.isOpened or config.isInputBoxDisplayed then return end
    if isDown then
        if key == controls.back then
            if #config.path == 1 then
                config.isOpened = false
            else
                table.remove(config.path)
            end
            playClickSound()
        end
        if key == controls.up then -- UP
            local submenu = config.path[#config.path]
            
            submenu.selectedOption = submenu.selectedOption - 1
            playClickSound()
        end
        if key == controls.down then -- DOWN
            local submenu = config.path[#config.path]

            submenu.selectedOption = submenu.selectedOption + 1
            playClickSound()
        end
        if key == controls.enter then -- ENTER
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.CLICK then
                    if selected.callback then selected.callback(selected) end
                elseif selected.type == OPTIONS.BOOL then
                    selected.value = not selected.value
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.NUM or selected.type == OPTIONS.FLOAT then
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.SUB then
                    if selected.callback then selected.callback(selected) end
                elseif selected.type == OPTIONS.TEXT_INPUT then
                    InputService:displayInputBox(nil, "text", function (text)
                        selected:setValue(text, true)
                        if selected.callback then selected.callback(selected.value, selected) end
                    end)
                end
                playClickSound()
            end
        end
        if key == controls.left then -- OPTION LEFT
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.NUM then
                    if selected.value - selected.step < selected.minValue then
                        selected.value = selected.maxValue
                    else
                        selected.value = selected.value - selected.step
                    end
                    playClickSound()
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.FLOAT then
                    if selected.value - selected.step < selected.minValue then
                        selected.value = selected.maxValue
                    else
                        selected.value = tonumber(tostring(selected.value - selected.step))
                    end
                    playClickSound()
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.value == 1 then
                        selected.value = #selected.table
                    else
                        selected.value = selected.value - 1
                    end
                    playClickSound()
                    if selected.execOnSelection then
                        if selected.callback then selected.callback(selected.value, selected) end
                    end
                end
            end
        end
        if key == controls.right then --OPTION RIGHT
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected then
                if selected.type == OPTIONS.NUM then
                    if selected.value + selected.step > selected.maxValue then
                        selected.value = selected.minValue
                    else
                        selected.value = selected.value + selected.step
                    end
                    playClickSound()
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.FLOAT then
                    if selected.value + selected.step > selected.maxValue then
                        selected.value = selected.minValue
                    else
                        selected.value = selected.value + selected.step
                    end
                    playClickSound()
                    if selected.callback then selected.callback(selected.value, selected) end
                elseif selected.type == OPTIONS.CHOOSE then
                    if selected.value == #selected.table then
                        selected.value = 1
                    else
                        selected.value = selected.value + 1
                    end
                    playClickSound()
                    if selected.execOnSelection then
                        if selected.callback then selected.callback(selected.value, selected) end
                    end
                end
            end
        end
        if key == gui.virualKeys.Delete then --Delete
            local submenu = config.path[#config.path]
            local selected = submenu.options[submenu.selectedOption]
            if selected.onDelete then
                selected.onDelete()
                selected:remove()
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

task.createTask("DrawUI_disableControls", 0.0, nil, function ()
    do
        Stuff.isTextChatActive = HUD._IS_MULTIPLAYER_CHAT_ACTIVE()
    end
    do -- DEBUG BLOCK
        if math.ceil(os.clock()) == DrawUI.dbg.lastSec then
            DrawUI.dbg.frameCount = DrawUI.dbg.frameCount + 1
        else
            DrawUI.dbg.lastSec = math.ceil(os.clock())
            DrawUI.dbg.fps = DrawUI.dbg.frameCount
            DrawUI.dbg.frameCount = 0
        end
    end
    if not config.isOpened then return end
    PAD.DISABLE_CONTROL_ACTION(2, 0, true) --INPUT_NEXT_CAMERA
    PAD.DISABLE_CONTROL_ACTION(2, 26, true) --INPUT_CREATOR_RT
    PAD.DISABLE_CONTROL_ACTION(2, 26, true) --INPUT_CREATOR_RT

    PAD.DISABLE_CONTROL_ACTION(2, 27, true) --INPUT_PHONE

    PAD.DISABLE_CONTROL_ACTION(2, 244, true) --INPUT_INTERACTION_MENU
    PAD.DISABLE_CONTROL_ACTION(2, 245, true) --INPUT_MP_TEXT_CHAT_ALL
    PAD.DISABLE_CONTROL_ACTION(2, 246, true) --INPUT_MP_TEXT_CHAT_TEAM
    PAD.DISABLE_CONTROL_ACTION(2, 247, true) --INPUT_MP_TEXT_CHAT_FRIENDS
    PAD.DISABLE_CONTROL_ACTION(2, 248, true) --INPUT_MP_TEXT_CHAT_CREW
end)

listener.register("DrawUI_controls", GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
    onControl(key, isDown, false)
end)


HOME_SUBMENU = Submenu.add_main_submenu("Home", "home_sub")

local settings = Submenu.add_static_submenu("Settings", "Main_Settings") do
    HOME_SUBMENU:add_sub_option("Settings", "Main_Settings", settings)
    -- settings:add_choose_option("Localization", "Main_Settings_localization", false, {"English", "Russian", "Chinese", "Custom"}, function (pos, option) 
    --     if pos == 1 then
    --         config.localization = nil
    --     elseif pos == 2 then
    --         config.localization = Localizations.russian
    --     elseif pos == 3 then
    --         config.localization = Localizations.chinese        
    --     elseif pos == 4 then
    --         config.localization = Localizations.custom
    --     end
    -- end)
    settings:add_choose_option("Controls", "Main_Settings_Controls", true, {"Arrows", "Numpad"}, function (pos, option)
        if pos == 1 then
            controls = arrowsControls
            Stuff.controlsState = {
                [arrowsControls.up] = {false, nil, nil},
                [arrowsControls.down] = {false, nil, nil},
                [arrowsControls.back] = {false, nil, nil},
                [arrowsControls.enter] = {false, nil, nil},
                [arrowsControls.left] = {false, nil, nil},
                [arrowsControls.right] = {false, nil, nil},
            }
            option:setHint("F8 - open key; arrows; Backspace and Enter.")
        else
            controls = numpadControls
            Stuff.controlsState = {
                [numpadControls.up] = {false, nil, nil},
                [numpadControls.down] = {false, nil, nil},
                [numpadControls.back] = {false, nil, nil},
                [numpadControls.enter] = {false, nil, nil},
                [numpadControls.left] = {false, nil, nil},
                [numpadControls.right] = {false, nil, nil},
            }
            option:setHint("Num * - open key; Numpad for everything.")
        end
    end)
    settings:add_float_option("UI width", "Main_Settings_Width", 0.0, 800.0, 5.0, function (val)
        config.width = val
    end):setValue(config.width)
    settings:add_float_option("Option height", "Main_Settings_Height", 5.0, 40.0, 1.0, function (val)
        config.optionHeight = val
    end):setValue(config.optionHeight)
    settings:add_float_option("Header height", "Main_Settings_headerHeight", 0.0, 120.0, 1.0, function (val)
        config.headerHeight = val
    end):setValue(config.headerHeight + .0)
    settings:add_num_option("UI offset [X]", "Main_Settings_OffsetX", 0.0, draw.get_window_width(), 10, function (val)
        config.offset_x = val
    end):setValue(config.offset_x)
    settings:add_num_option("UI offset [Y]", "Main_Settings_OffsetY", 0.0, draw.get_window_height(), 10, function (val)
        config.offset_y = val
    end):setValue(config.offset_y)
    settings:add_bool_option("Smooth scroller", "Main_Settings_SmoothScroller", function (state)
        config.enabelSmoothScroller = state
    end):setValue(true)
    settings:add_num_option("Rendered options limit", "Main_Settings_Limit", 1, 25, 1, function (val)
        config.maxOptions = val
    end):setValue(config.maxOptions)
    settings:add_float_option("UI input delay", "Main_Settings_InputDelay", 0.0, 1.0, 0.05, function (val)
        config.inputDelay = val
    end):setValue(config.inputDelay)
    settings:add_bool_option("Play menu sounds", "Main_Settings_PlayMenuSounds", function (state)
        config.isClickSoundEnabled = state
    end):setValue(false)
    settings:add_bool_option("Render slider", "Main_Settings_Slider", function (state)
        config.drawSlider = state
    end):setValue(true)
    settings:add_bool_option("Render submenu path", "Main_Settings_SubmenuPath", function (state)
        config.showPath = state
    end):setValue(true)
    settings:add_bool_option("Render navigation bar", "Main_Settings_KeysPanel", function (state)
        config.drawKeysPanel = state
    end):setValue(true)
    -- local keys = Submenu.add_static_submenu("Keys", "Main_Settings_Keys") do
    --     keys:add_text_input()
    -- end
    settings:add_separator("Config", "Main_Settings_Config")
    settings:add_click_option("Save config", "Main_Settings_SaveConfig", Configs.saveConfig)
    settings:add_click_option("Load config", "Main_Settings_LoadConfig", Configs.loadConfig)
    -- local sub = Submenu.add_static_submenu("Search", "") do
    --     local name = sub:add_text_input("Name", "", function (txt)
    --         for hash, option in pairs(searchOptions) do
    --             if string.find(string.lower(option.name), string.lower(txt)) then
    --                 table.insert(sub.options, option)
    --                 print(option.name)
    --             end
    --         end
    --     end)
    --     settings:add_sub_option("Search", "", sub)
    -- end
end

listener.register("DrawUI_render", GET_EVENTS_LIST().OnFrame, function ()
    draw.set_rounding(0)

    -- draw.set_font(materials.font)

    if not config.isOpened then return end

    local submenu = config.path[#config.path]

    local function getClickableOption(selectedOption)
        if #submenu.options < 2 then return 1 end
        if selectedOption < 1 then 
            return getClickableOption(#submenu.options)
        end
        if selectedOption > #submenu.options then
            return getClickableOption(1)
        end
        local option = submenu.options[selectedOption] or {}
        if option.type ~= OPTIONS.SEPARATOR and option.type ~= OPTIONS.STATE_BAR then
            return selectedOption
        else
            if submenu.prevOption < submenu.selectedOption then
                return getClickableOption(selectedOption + 1)
            elseif submenu.prevOption > submenu.selectedOption then
                return getClickableOption(selectedOption - 1)
            end
        end
    end

    submenu.selectedOption = getClickableOption(submenu.selectedOption)
    submenu.prevOption = submenu.selectedOption

    if submenu.isDynamic then
        for ID, option in ipairs(submenu.options) do
            Option.remove(option)
        end
        submenu.getter(submenu)
    end

    if #submenu.options == 0 then
        submenu:setActive(false)
        submenu = config.path[#config.path]
        notify.default("DrawUI", "There is nothing to see yet.")
    end

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
    draw.set_color(0, 14, 17, 19, 255) -- BACKGROUND
    draw.rect_filled(
        bg.lu.x, 
        bg.lu.y, 
        bg.rd.x, 
        bg.rd.y)
        -- draw.texture(
        --     materials.bg,
        --     bg.lu.x, 
        --     bg.lu.y - config.optionHeight,
        --     config.width,
        --     bg.rd.y - bg.lu.y + config.optionHeight
        -- )
    
    draw.set_color(0, 19, 22, 25, 255) -- SUBMENU NAME BG
    draw.rect_filled(
        bg.lu.x,
        bg.lu.y - config.optionHeight,
        bg.rd.x,
        bg.lu.y
    )
    
    local pos = string.format("%i/%i", submenu.selectedOption, #submenu.options)
    draw.set_color(0, 255, 255, 255, 255) -- OPTIONS x/y
    draw.text(
        bg.rd.x - draw.get_text_size_x(pos) - 10,
        -- (bg.rd.y + 30 - config.optionHeight - (bg.rd.y - config.optionHeight - bg.rd.y)/2) - draw.get_text_size_y(pos)/2,
        (bg.lu.y - config.optionHeight) + config.optionHeight/2 - draw.get_text_size_y(pos)/2,
        pos
    )

    local path = ""
    if config.showPath then
        for _, submenu in ipairs(config.path) do
            path = path .. submenu.name .. "/"
        end
    else
        path = tostring(config.path[#config.path].name)
    end

    do
        local function cropString(text_s, len_n)
            if len_n <= 0 then return "" end
            if string.len(text_s) == 0 then return "" end
            if draw.get_text_size(text_s).x <= len_n then return text_s end
            return cropString(text_s:sub(2, text_s:len()), len_n)
        end
        local maxLen = bg.rd.x - draw.get_text_size_x(pos) - 30 - bg.lu.x
        if draw.get_text_size_x(path) > maxLen then
            path = "..." .. cropString(path, maxLen - draw.get_text_size_x("..."))
        end
    end

    draw.set_color(0, 255, 255, 255, 255) -- SUBMENU NAME TEXT
    draw.text(
        bg.lu.x + 10,
        (bg.lu.y - config.optionHeight - (bg.lu.y - config.optionHeight - bg.lu.y)/2) - draw.get_text_size_y(path)/2,
        path
    )
    
    draw.texture( -- HEADER
    materials.header,
    bg.lu.x,
    -- bg.lu.y - config.optionHeight - 90,
    bg.lu.y - config.headerHeight - config.optionHeight,
    config.width,
    config.headerHeight
    )

    draw.set_color(0, 34, 41, 47, 255) -- FOOTER
    draw.rect_filled(
        bg.lu.x,
        bg.rd.y,
        bg.rd.x,
        bg.rd.y + config.optionHeight
    )

    draw.texture( -- FOOTER ARROWS
        materials.footerArrows,
        bg.lu.x + config.width/2 - config.footerArrowsSize/2 - 2, 
        bg.rd.y + config.optionHeight/2 - config.footerArrowsSize/2, 
        config.footerArrowsSize + 2,
        config.footerArrowsSize
    )

    draw.set_color(0, 255, 255, 255, 255)
    draw.text( -- VERSION
        bg.lu.x + 10,
        bg.rd.y + config.optionHeight/2 - draw.get_text_size_y(BSVERSION)/2,
        BSVERSION
    )
    
    if submenu.options[submenu.selectedOption] then
        local data = submenu.options[submenu.selectedOption]
        
        local scrollerEnd = {}
        scrollerEnd.leftUpper = {
            x = bg.lu.x,
            y = bg.lu.y + config.optionHeight * (submenu.selectedOption < config.maxOptions and submenu.selectedOption - 1 or config.maxOptions - 1),
        }
        scrollerEnd.rightDown = {
            x = bg.rd.x,
            y = scrollerEnd.leftUpper.y + config.optionHeight
        }
        
        if not submenu.scrollerPos then submenu.scrollerPos = scrollerEnd end
        
        if config.enabelSmoothScroller then
            local scrollerSpeed = 3
            if submenu.scrollerPos.leftUpper.y < scrollerEnd.leftUpper.y then -- CREDITS TO 1tsPxel
                submenu.scrollerPos.leftUpper.y = math.min(scrollerEnd.leftUpper.y, submenu.scrollerPos.leftUpper.y + scrollerSpeed)
            elseif submenu.scrollerPos.leftUpper.y > scrollerEnd.leftUpper.y then
                submenu.scrollerPos.leftUpper.y = math.max(scrollerEnd.leftUpper.y, submenu.scrollerPos.leftUpper.y - scrollerSpeed)
            end
        else
            submenu.scrollerPos = scrollerEnd
        end

        draw.set_color(0, 34, 41, 47, 255)
        draw.rect_filled( -- SELECTED OPTION
            scrollerEnd.leftUpper.x,
            submenu.scrollerPos.leftUpper.y,
            scrollerEnd.rightDown.x,
            submenu.scrollerPos.leftUpper.y + config.optionHeight
        )

        if data.hint ~= "" then
            draw.set_color(0, 255, 255, 255, 255)
            local hint = tostring(submenu.options[submenu.selectedOption].hint)
            if hint ~= "" then
                local y = bg.rd.y + config.optionHeight + 10
                draw.set_color(0, 34, 41, 47, 255)
                draw.rect_filled(
                    bg.lu.x,
                    y, 
                    bg.rd.x,
                    y + 5 + draw.get_text_size_y(hint) + 5
                )
                -- draw.texture(
                --     materials.hintBox,
                --     bg.lu.x,
                --     y,
                --     config.width,
                --     config.optionHeight
                -- )
                draw.set_color(0, 255, 255, 255, 255)
                draw.text(
                    bg.lu.x + 10,
                    (y + 5 + draw.get_text_size_y(hint) + 5 - (y + 5 + draw.get_text_size_y(hint) + 5 - y)/2) - draw.get_text_size_y(hint)/2,
                    hint
                )
            end
        end
    end

    -- SLIDER
    if config.drawSlider then
        local padding = 5
        local sliderItemPadding = 2
        local verticalPadding = 2
        local width = 10
        local sliderBox = {
            leftUpper = {
                x = bg.rd.x + padding,
                y = bg.lu.y,
            },
            rightDown = {
                x = bg.rd.x + padding + width,
                y = bg.rd.y,
            }
        }
        local sliderHeight = (sliderBox.rightDown.y - sliderBox.leftUpper.y - verticalPadding*2) / #submenu.options
        sliderHeight = sliderHeight > 1.0 and sliderHeight or 0.0

        local sliderItemEnd = {}
        sliderItemEnd.leftUpper = {
            x = sliderBox.leftUpper.x + sliderItemPadding,
            y = sliderBox.leftUpper.y + verticalPadding + sliderHeight * (submenu.selectedOption - 1),
        }
        sliderItemEnd.rightDown = {
            x = sliderBox.rightDown.x - sliderItemPadding,
            y = sliderItemEnd.leftUpper.y + sliderHeight
        }
        
        if not submenu.sliderPos then submenu.sliderPos = sliderItemEnd end

        local sliderPosSpeed = 3

        if submenu.sliderPos.leftUpper.y < sliderItemEnd.leftUpper.y then -- CREDITS TO 1tsPxel
            submenu.sliderPos.leftUpper.y = math.min(sliderItemEnd.leftUpper.y, submenu.sliderPos.leftUpper.y + sliderPosSpeed)
        elseif submenu.sliderPos.leftUpper.y > sliderItemEnd.leftUpper.y then
            submenu.sliderPos.leftUpper.y = math.max(sliderItemEnd.leftUpper.y, submenu.sliderPos.leftUpper.y - sliderPosSpeed)
        end

        if sliderHeight > 0.0 then
            draw.set_color(0, 14, 17, 19, 255)
            draw.set_rounding(16)
            
            draw.rect_filled( -- SLIDER BOX
                sliderBox.leftUpper.x,
                sliderBox.leftUpper.y,
                sliderBox.rightDown.x,
                sliderBox.rightDown.y
            )

            draw.set_color(0, 83, 180, 223, 255)
            draw.set_rounding(10)

            local sliderItem = submenu.sliderPos
            draw.rect_filled( -- SLIDER ITEM
                sliderItemEnd.leftUpper.x,
                sliderItem.leftUpper.y,
                sliderItemEnd.rightDown.x,
                sliderItem.leftUpper.y + sliderHeight
            )

            draw.set_rounding(0)
        end
    end
    
    local optionID = 0
    local firstOption = math.max(0, submenu.selectedOption - config.maxOptions) + 1
    local lastOption = firstOption + math.min(config.maxOptions, #submenu.options) - 1
    

    for i = firstOption, lastOption do -- RENDERING OPTIONS NAMES
        optionID = optionID + 1
        local data = submenu.options[i]

        local textEnd = {}
        textEnd.leftUpper = {
            x = bg.lu.x,
            y = bg.lu.y + config.optionHeight*(optionID - 1),
        }
        textEnd.rightDown = {
            x = bg.rd.x, 
            y = textEnd.leftUpper.y + config.optionHeight,
        }

        config.iconsSize = 40
        local symbol = nil
        local material = nil
        if data.type == OPTIONS.CLICK then
            -- do smth
        elseif data.type == OPTIONS.BOOL then
            material = materials.toggleOff
            if data.value then material = materials.toggleOn end
        elseif data.type == OPTIONS.NUM then
            symbol = string.format("<%i of %i>", data.value, data.maxValue)
        elseif data.type == OPTIONS.FLOAT then
            symbol = string.format("<%s of %s>", data.value, data.maxValue)
        elseif data.type == OPTIONS.CHOOSE then
            symbol = #data.table > 0 and string.format("<%s (%i/%i)>", data.table[data.value], data.value, #data.table) or "None"
        elseif data.type == OPTIONS.SUB then
            material = materials.sub
        elseif data.type == OPTIONS.TEXT_INPUT then
            if data.value == "" then
                symbol = "[Empty]"
            else
                symbol = string.format("[%s]", data.value)
            end
        elseif data.type == OPTIONS.STATE_BAR then
            symbol = tostring(data.getter())
        end

        local name = tostring(data.name)
        if config.localization then
            name = config.localization[data.hash] or data.hash
        end
        local maxNameLen = bg.rd.x - (symbol and draw.get_text_size_x(symbol) or config.iconsSize) - 30 - bg.lu.x
        if draw.get_text_size_x(name) > maxNameLen then
            name = draw.crop_text(name, maxNameLen - draw.get_text_size_x("...")) .. "..."
        end

        local textLeftPagging = 10

        -- if data.hotkey then
        --     local key = data.hotkey
        --     local textSize = draw.get_text_size(key)
        --     draw.set_rounding(3)
        --     draw.set_color(0, 83, 180, 223, 255)
        --     draw.rect_filled(
        --         textEnd.leftUpper.x + textLeftPagging,   
        --         textEnd.leftUpper.y + config.optionHeight/2 - textSize.y/2,
        --         textEnd.leftUpper.x + textLeftPagging + textSize.x + 4*2,
        --         textEnd.leftUpper.y + config.optionHeight/2 + textSize.y/2
        --     )
        --     draw.set_rounding(0)
        --     draw.set_color(0, 0, 0, 0, 255)
        --     draw.text(
        --         textEnd.leftUpper.x + textLeftPagging + 4,
        --         textEnd.leftUpper.y + config.optionHeight/2 - textSize.y/2,
        --         key
        --     )
        --     textLeftPagging = textLeftPagging + textSize.x + 4 + 8
        -- end

        draw.set_color(0, 255, 255, 255, 255)
        draw.text(
            (data.type ~= OPTIONS.SEPARATOR) and (textEnd.leftUpper.x + textLeftPagging) or ((textEnd.leftUpper.x + (config.width)/2) - draw.get_text_size_x(name)/2),
            textEnd.leftUpper.y + config.optionHeight/2 - draw.get_text_size_y(name)/2,
            name
        )

        local lu, rd = textEnd.leftUpper, textEnd.rightDown

        if data.type == OPTIONS.SEPARATOR then
            draw.set_thickness(2)
            draw.set_color(0, 100, 100, 100, 255)
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
            draw.set_thickness(0)
            draw.set_color(0, 255, 255, 255, 255)
        end
        local offset = 5.0
        for _, t in ipairs(data.tags) do                      
            draw.set_color(0, t[2], t[3], t[4], 255)
            draw.text(
                lu.x + 10 + draw.get_text_size_x(name) + offset,
                (rd.y - (rd.y - lu.y)/2) - draw.get_text_size_y(t[1])/2,
                t[1]
            )
            offset = offset + draw.get_text_size_x(t[1]) + 4
        end

        draw.set_color(0, 255, 255, 255, 255)

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

    if config.drawKeysPanel then -- KEYS PANEL
        local coords = {
            leftUpper = {
                x = draw.get_window_width() - 10 - 10,
                y = draw.get_window_height() - 10 - config.optionHeight,
            },
            rightDown = {
                x = draw.get_window_width() - 10,
                y = draw.get_window_height() - 10,
            },
        }
        local keys = {
            {key = features.getVirtualKeyViaID(controls.open), note = "Open/Hide UI"},
        }
        local option = submenu.options[submenu.selectedOption] or {}
        if option.hotkey then
            table.insert(keys, {key = option.hotkey, note = "Hotkey"})
            table.insert(keys, {key = "F11", note = "Remove a hotkey"})
        elseif option.isHotkeyable then
            table.insert(keys, {key = "F11", note = "Set a hotkey"})
        end
        if option.onDelete then
            table.insert(keys, {key = "Del", note = "Delete"})
        end
        if config.isInputBoxDisplayed then
            keys = {
                {key = "Enter", note = "Ok"},
                {key = "ESC", note = "Cancel"},
            }
        end
        do
            local boxCoords = {
                leftUpper = {
                    x = coords.rightDown.x - 10
                },
            }
            for _, key_t in ipairs(keys) do
                boxCoords.leftUpper.x = boxCoords.leftUpper.x - 10 - draw.get_text_size_x(key_t.key) - 10 - draw.get_text_size_x(key_t.note)
            end
            draw.set_color(0, 34, 41, 47, 255)
            draw.set_rounding(5)
            draw.rect_filled(
                boxCoords.leftUpper.x,
                coords.leftUpper.y,
                coords.rightDown.x,
                coords.rightDown.y
            )
            draw.set_rounding(0)
        end
        for _, key_t in ipairs(keys) do
            draw.set_color(0, 255, 255, 255, 255)
            draw.text(
                coords.leftUpper.x - draw.get_text_size_x(key_t.note),
                (coords.rightDown.y - (coords.rightDown.y - coords.leftUpper.y)/2) - draw.get_text_size_y(key_t.note)/2,
                key_t.note
            )
            coords.leftUpper.x = coords.leftUpper.x - 10 - draw.get_text_size_x(key_t.note)
            draw.set_color(0, 83, 180, 223, 255)
            draw.set_rounding(3)
            draw.rect_filled(
                coords.leftUpper.x - draw.get_text_size_x(key_t.key) - 2,
                (coords.rightDown.y - (coords.rightDown.y - coords.leftUpper.y)/2) - draw.get_text_size_y(key_t.key)/2,
                coords.leftUpper.x + 2,
                (coords.rightDown.y - (coords.rightDown.y - coords.leftUpper.y)/2) + draw.get_text_size_y(key_t.key)/2
            )
            draw.set_rounding(0)
            draw.set_color(0, 0, 0, 0, 255)
            draw.text(
                coords.leftUpper.x - draw.get_text_size_x(key_t.key),
                (coords.rightDown.y - (coords.rightDown.y - coords.leftUpper.y)/2) - draw.get_text_size_y(key_t.key)/2,
                key_t.key
            )
            coords.leftUpper.x = coords.leftUpper.x - 10 - draw.get_text_size_x(key_t.key)
        end
    end
end)