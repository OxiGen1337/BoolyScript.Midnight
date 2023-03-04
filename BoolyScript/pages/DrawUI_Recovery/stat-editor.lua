local sMP, iMP = "MP", 0 -- TODO: char ID 

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
end)

ST:add_separator("Int", "BS_StatEditor_IntSeparator")

local statNameI = ST:add_text_input("Name", "BS_StatEditor_IntName"):setConfigIgnore()

local iValue = ST:add_text_input("Value", "BS_StatEditor_IntValue"):setValue("1"):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_IntSet", function(option)
    STATS.STAT_SET_INT(string.joaat(sMP .. tostring(statNameI:getValue())), tonumber(iValue:getValue()), true)
    STATS.STAT_SAVE(0, 0, 3, 0)
end)

ST:add_separator("Float", "BS_StatEditor_FloatSeparator")

local statNameF = ST:add_text_input("Name", "BS_StatEditor_FloatName"):setConfigIgnore()

local fValue = ST:add_text_input("Value", "BS_StatEditor_FloatValue"):setValue("1.0"):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_FloatSet", function(option)
    STATS.STAT_SET_FLOAT(string.joaat(sMP .. tostring(statNameF:getValue())), s2f(fValue:getValue()), true)
    STATS.STAT_SAVE(0, 0, 3, 0)
end)
