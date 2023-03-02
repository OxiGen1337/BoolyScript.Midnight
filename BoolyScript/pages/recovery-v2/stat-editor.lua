ST:add_separator("Bool", "BS_StatEditor_BoolSeparator")

local statNameB = ST:add_text_input("Name", "BS_StatEditor_BoolName"):setConfigIgnore()

local bValue = false

ST:add_choose_option("Value", "BS_StatEditor_BoolValue", true, {"FALSE", "TRUE"}, function (value, option)
    bValue = value
end):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_BoolSet", function(option)
    STATS.STAT_SET_BOOL(string.joaat(tostring(statNameB)), bValue, true)
    STATS.STAT_SAVE(0, 0, 3, 0)
end)

ST:add_separator("Int", "BS_StatEditor_IntSeparator")

local statNameI = ST:add_text_input("Name", "BS_StatEditor_IntName"):setConfigIgnore()

local iValue = 0

local INT_MAX = 2147483647

local INT_MIN = -2147483647

ST:add_num_option("Value", "BS_StatEditor_IntValue", INT_MIN, INT_MAX, 1, function (val)
    iValue = val
end):setValue(0, true):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_IntSet", function(option)
    STATS.STAT_SET_INT(string.joaat(tostring(statNameI)), iValue, true)
    STATS.STAT_SAVE(0, 0, 3, 0)
end)