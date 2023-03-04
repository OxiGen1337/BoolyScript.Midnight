local sMP, iMP = "", scripts.globals.getCharId()

ST:add_bool_option("Add MP0_/MP1_", "BS_StatEditor_MP01", function (state, option)
    if state then sMP = "MP" .. iMP .. "_" else sMP = "" end
end):setValue(false):setConfigIgnore()

ST:add_separator("Bool", "BS_StatEditor_BoolSeparator")

local statNameB = ST:add_text_input("Name", "BS_StatEditor_BoolName"):setConfigIgnore()

local bValue = false

ST:add_choose_option("Value", "BS_StatEditor_BoolValue", true, {"FALSE", "TRUE"}, function (value, option)
    bValue = value == 2
end):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_BoolSet", function(option)
    STATS.STAT_SET_BOOL(string.joaat(sMP .. tostring(statNameB:getValue())), bValue, true)
    STATS.STAT_SAVE(0, 0, 3, 0)
    notify.success("Set Bool", "Modified stat " .. name .. " with value " .. tonumber(bValue:getValue()))
end)

ST:add_separator("Number", "BS_StatEditor_NumSeparator")

local iVar = 1

ST:add_choose_option("Var", "BS_StatEditor_NumVar", true, {"Int", "Float"}, function (value, option)
    iVar = value
end):setValue(1):setConfigIgnore()

local statNameN = ST:add_text_input("Name", "BS_StatEditor_NumName"):setConfigIgnore()

local nValue = ST:add_text_input("Value", "BS_StatEditor_NumValue"):setValue("1"):setConfigIgnore()

ST:add_choose_option("Set", "BS_StatEditor_NumSet", false, {"Force", "Increment"}, function (value, option)
    local name = sMP .. tostring(statNameN:getValue())
    if value == 1 then
        if iVar == 1 then
            STATS.STAT_SET_INT(string.joaat(name), tonumber(nValue:getValue()), true)
        else
            STATS.STAT_SET_FLOAT(string.joaat(name), s2f(nValue:getValue()), true)
        end
        notify.success("Set Number", "Modified stat " .. name .. " with value " .. nValue:getValue())
    else
        STATS.STAT_INCREMENT(string.joaat(name), s2f(nValue:getValue()))
        notify.success("Number Increment", "Modified stat " .. name .. " with value " .. nValue:getValue())
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end)

ST:add_separator("String", "BS_StatEditor_StringSeparator")

local statNameS = ST:add_text_input("Name", "BS_StatEditor_StringName"):setConfigIgnore()

local sValue = ST:add_text_input("Value", "BS_StatEditor_StringValue"):setValue("BOOLY"):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_StringSet", function(option)
    local name = sMP .. tostring(statNameS:getValue())
    STATS.STAT_SET_STRING(string.joaat(name), sValue:getValue(), true)
    STATS.STAT_SAVE(0, 0, 3, 0)
    notify.success("Set String", "Modified stat " .. name .. " with value " .. sValue:getValue())
end)

ST:add_separator("Other", "BS_StatEditor_DangerZone")

ST:add_click_option("Disable tracking", "BS_StatEditor_DangerZoneDT", function(option)
    STATS.STAT_DISABLE_STATS_TRACKING()
    notify.warning("Stat Editor", "Stat tracking & updates are now disabled")
end):setTags({{"[!]", 255, 5, 10}}):setHint("Prevents stat tracking & updates to CStatsMgr")