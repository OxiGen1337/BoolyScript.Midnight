local sMP, iMP = "", scripts.globals.getCharId()
local MP = "MP" .. iMP .. "_"
local sJ = string.joaat

do
    local statList = {
        "MPPLY_KILLS_PLAYERS",
        "MPPLY_DEATHS_PLAYER",
        "MPPLY_DEATHS_PLAYER_SUICIDE",
        "MPPLY_KILL_DEATH_RATIO",
        "MP_PLAYING_TIME",
        "MP_PLAYING_TIME_NEW",
        MP .. "TOTAL_PLAYING_TIME",
        "MPPLY_CREW_LOCAL_XP_0",
        "MPPLY_CREW_GLOBAL_XP_0",
        "MPPLY_CREW_LOCAL_XP_1",
        "MPPLY_CREW_GLOBAL_XP_1",
        "MPPLY_CREW_LOCAL_XP_2",
        "MPPLY_CREW_GLOBAL_XP_2",
        "MPPLY_CREW_LOCAL_XP_3",
        "MPPLY_CREW_GLOBAL_XP_3",
        "MPPLY_CREW_LOCAL_XP_4",
        "MPPLY_CREW_GLOBAL_XP_4",
        "MPPLY_TOTAL_RACES_WON",
        "MPPLY_TOTAL_CUSTOM_RACES_WON",
        "MPPLY_TOTAL_RACES_LOST",
        "MPPLY_TOTAL_DEATHMATCH_WON",
        "MPPLY_TOTAL_DEATHMATCH_LOST",
        "MPPLY_TOTAL_TDEATHMATCH_WON",
        "MPPLY_TOTAL_TDEATHMATCH_LOST",
        "MPPLY_SHOOTINGRANGE_WINS",
        "MPPLY_SHOOTINGRANGE_LOSSES",
        "MPPLY_TENNIS_MATCHES_WON",
        "MPPLY_TENNIS_MATCHES_LOST",
        "MPPLY_GOLF_WINS",
        "MPPLY_GOLF_LOSSES",
        "MPPLY_DARTS_TOTAL_WINS",
        "MPPLY_DARTS_TOTAL_MATCHES",
        "MPPLY_SHOOTINGRANGE_TOTAL_MATCH",
        "MPPLY_BJ_WINS",
        "MPPLY_BJ_LOST",
        "MPPLY_RACE_2_POINT_WINS",
        "MPPLY_RACE_2_POINT_LOST",
        "MPPLY_TOTAL_TIME_SPENT_DEATHMAT",
        "MPPLY_TOTAL_TIME_SPENT_FREEMODE",
        "MPPLY_TOTAL_TIME_MISSION_CREATO",
        "MPPLY_TOTAL_TIME_SPENT_RACES",
        "MPPLY_TOTAL_TIME_SPENT_ON_MISS",
        "MPPLY_ARMWRESTLING_TOTAL_WINS",
        "MPPLY_ARMWRESTLING_TOTAL_MATCH",
        "MPPLY_FM_MISSION_LIKES",
        "MPPLY_LTS_CREATED",
        "MPPLY_NUM_CAPTURES_CREATED",
        "MPPLY_CRMISSION",
        "MPPLY_MCMWIN",
        "MPPLY_CRHORDE",
        "MPPLY_HORDEWINS",
        MP .. "SHOTS",
        MP .. "KILLS",
        MP .. "HEADSHOTS",
        MP .. "PLAYER_HEADSHOTS",
        MP .. "KILLS_ARMED",
        MP .. "KILLS_STEALTH",
        MP .. "SUCCESSFUL_COUNTERS",
        MP .. "DM_HIGHEST_KILLSTREAK",
        MP .. "EXPLOSIVE_DAMAGE_HITS",
        MP .. "EXPLOSIVE_DAMAGE_HITS_ANY",
        MP .. "EXPLOSIVE_DAMAGE_SHOTS",
        MP .. "EXPLOSIVES_USED",
        MP .. "HITS",
        MP .. "HITS_PEDS_VEHICLES",
        MP .. "DEATHS",
        MP .. "DIED_IN_EXPLOSION",
        MP .. "DIED_IN_FALL",
        MP .. "DIED_IN_FIRE",
        MP .. "DIED_IN_ROAD",
        MP .. "DIED_IN_DROWNING",
        MP .. "BOUNTPLACED",
        MP .. "BOUNTSONU",
        MP .. "DEATHS_PLAYER",
        MP .. "UNARMED_KILLS",
        MP .. "UNARMED_ENEMY_KILLS",
        MP .. "UNARMED_DEATHS",
        MP .. "UNARMED_HITS"
    }
    
    local statOpt = {}

    ST_CH = Submenu.add_static_submenu("Character", "BS_StatEditor")
    ST:add_sub_option("Character", "BS_StatEditorCharacter", ST_CH):setTags({{"[Pre-defined]", 247, 79, 236}})

    local saveValue = true
    ST_CH:add_bool_option("Save", "BS_StatEditorCharacter_SaveValue", function (state, option)
        saveValue = state
    end):setValue(true):setConfigIgnore()


    ST_CH:add_choose_option("Action", "BS_StatEditorCharacter_StatAction", true, {"Modify", "View"}, function (value, option)
        for _, opt in ipairs(statOpt) do
            opt:remove()
        end
        statOpt = {}

        table.insert(statOpt, ST_CH:add_separator("Stats", "BS_StatEditorCharacter_Stats"))

        switch(option:getTable()[value], {
            ["Modify"] = function ()
                for _, stat in ipairs(statList) do
                    table.insert(statOpt, ST_CH:add_text_input(stat, "BS_StatEditorCharacter_" .. stat, function (enteredText)
                        if stat == "MPPLY_KILL_DEATH_RATIO" then
                            stats.set_float(sJ(stat), s2f(enteredText))
                        else
                            stats.set_u64(sJ(stat), s2i(enteredText))
                        end
                        if saveValue then STATS.STAT_SAVE(0, 0, 3, 0) end
                        notify.success("Character Stat", "Modified stat '{}' with value {}", stat, enteredText)
                    end):setConfigIgnore())
                end
            end,
            ["View"] = function ()
                for _, stat in ipairs(statList) do
                    table.insert(statOpt, ST_CH:add_state_bar(stat, "BS_StatEditorCharacter_" .. stat, function ()
                        if stat == "MPPLY_KILL_DEATH_RATIO" then
                            return stats.get_float(sJ(stat))
                        else
                            return stats.get_u64(sJ(stat))
                        end
                    end):setSelectable(true))
                end  
            end
        })
    end):setValue(1)
end

ST:add_bool_option("Add MP0_/MP1_", "BS_StatEditor_MP01", function (state, option)
    if state then sMP = MP else sMP = "" end
end):setValue(false):setConfigIgnore()

local saveValue = true
ST:add_bool_option("Save", "BS_StatEditor_SaveValue", function (state, option)
    saveValue = state
end):setValue(true):setConfigIgnore()

ST:add_separator("Bool", "BS_StatEditor_BoolSeparator")

local statNameB = ST:add_text_input("Name", "BS_StatEditor_BoolName"):setConfigIgnore()

local bValue = false

ST:add_choose_option("Value", "BS_StatEditor_BoolValue", true, {"FALSE", "TRUE"}, function (value, option)
    bValue = value == 2
end):setValue(1):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_BoolSet", function(option)
    local name = sMP .. tostring(statNameB:getValue())
    STATS.STAT_SET_BOOL(sJ(name), bValue, saveValue)
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
            STATS.STAT_SET_INT(sJ(name), tonumber(nValue:getValue()), saveValue)
        else
            STATS.STAT_SET_FLOAT(sJ(name), s2f(nValue:getValue()), saveValue)
        end
        notify.success("Set Number", "Modified stat " .. name .. " with value " .. nValue:getValue())
    else
        STATS.STAT_INCREMENT(sJ(name), s2f(nValue:getValue()))
        if saveValue then STATS.STAT_SAVE(0, 0, 3, 0) end
        notify.success("Number Increment", "Modified stat " .. name .. " with value " .. nValue:getValue())
    end
end)

ST:add_separator("String", "BS_StatEditor_StringSeparator")

local statNameS = ST:add_text_input("Name", "BS_StatEditor_StringName"):setConfigIgnore()

local sValue = ST:add_text_input("Value", "BS_StatEditor_StringValue"):setValue("BOOLY"):setConfigIgnore()

ST:add_click_option("Set", "BS_StatEditor_StringSet", function(option)
    local name = sMP .. tostring(statNameS:getValue())
    STATS.STAT_SET_STRING(sJ(name), sValue:getValue(), saveValue)
    notify.success("Set String", "Modified stat " .. name .. " with value " .. sValue:getValue())
end)

ST:add_separator("Other", "BS_StatEditor_DangerZone")

ST:add_click_option("Open stat list", "BS_StatEditor_ViewStats", function(option)
    os.execute("start https://gist.github.com/1337Nexo/945fe9724b9dd20d33e7afeabd2746dc")
end)

ST:add_click_option("Disable tracking", "BS_StatEditor_DangerZoneDT", function(option)
    STATS.STAT_DISABLE_STATS_TRACKING()
    notify.warning("Stat Editor", "Stat tracking & updates are now disabled")
end):setTags({{"[!]", 255, 5, 10}}):setHint("Prevents stat tracking & updates to CStatsMgr")