Recovery = Submenu.add_static_submenu("Recovery", "BS_Recovery")
Main:add_sub_option("Recovery", "BS_Recovery", Recovery)

-- Recovery:add_click_option("Summon the Gooch", "BS_Recovery_Gooch", function ()
--     scripts.globals.callGooch()
-- end)

-- Recovery:add_separator("Nightclub", "BS_Recovery_Nightclub")

Recovery:add_click_option("How to use", "BS_Recovery_Nightclub_HowToUse", function()
    notify.important("Nightclub recovery", "Buy a nightclub\nSetup the nightclub\nOnce completely setup\nGo inside\nUse Tp to safe\nOpen safe\nTurn on nightclub money loop")
end)

Recovery:add_click_option("TP to safe", "BS_Recovery_Nightclub_TpToSafe", function()
    local coords = Vector3(-1615.6827392578, -3015.6813964844, -75.205070495605)
    if not coords then return end
    features.teleport(coords)
end)

Recovery:add_bool_option("Nightclub money loop", "BS_Recovery_Nightclub_Enable", function(state)
    if state then 
        notify.warning("Nightclub recovery", "Use at own risk.")
        script_global:new(262145):at(23084):set_int64(133377)
        task.createTask("BS_Recovery_Nightclub_Enable", 5.0, nil, function ()
            script_global:new(262145):at(24045):set_int64(300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
            script_global:new(262145):at(24041):set_int64(300000) -- KEEP AT 300000 OR YOU WILL NEED TO DELETE & RE-MAKE YOUR CHARACTER, IT WILL BUG THE NIGHTCLUB SAFE!
            for _, char in ipairs({"MP0_", "MP1_"}) do
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_POPULARITY"), 10000, true)
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_PAY_TIME_LEFT"), -1, true)
                STATS.STAT_SET_INT(string.joaat(char .. "CLUB_POPULARITY"), 100000, true)
            end
        end)
    elseif task.exists("BS_Recovery_Nightclub_Enable") then
        task.removeTask("BS_Recovery_Nightclub_Enable")
    end
end)

Recovery:add_separator("Collectibles", "BS_Recovery_Collectibles")

local figuresSub = Submenu.add_static_submenu("Figures", "BS_Recovery_Collectibles_Figures") do
    local figures = {{3514,3754,35},{3799,4473,7},{3306,5194,18},{2937,4620,48},{2725,4142,44},{2487,3759,43},{1886,3913,33},{1702,3290,48},{1390,3608,34},{1298,4306,37},{1714,4791,41},{2416,4994,46},{2221,5612,55},{1540,6323,24},{1310,6545,5},{457,5573,781},{178,6394,31},{-312,6314,32},{-689,5829,17},{-552,5330,75},{-263,4729,138},{-1121,4977,186},{-2169,5192,17},{-2186,4250,48},{-2172,3441,31},{-1649,3018,32},{-1281,2550,18},{-1514,1517,111},{-1895,2043,142},{-2558,2316,33},{-3244,996,13},{-2959,386,14},{-3020,41,10},{-2238,249,176},{-1807,427,132},{-1502,813,181},{-770,877,204},{-507,393,97},{-487,-55,39},{-294,-343,10},{-180,-632,49},{-108,-857,39},{-710,-906,19},{-909,-1149,2},{-1213,-960,1},{-1051,-523,36},{-989,-102,40},{-1024,190,62},{-1462,182,55},{-1720,-234,55},{-1547,-449,40},{-1905,-710,8},{-1648,-1095,13},{-1351,-1547,4},{-887,-2097,9},{-929,-2939,13},{153,-3078,7},{483,-3111,6},{-56,-2521,7},{368,-2114,17},{875,-2165,32},{1244,-2573,43},{1498,-2134,76},{1207,-1480,34},{679,-1523,9},{379,-1510,29},{-44,-1749,29},{-66,-1453,32},{173,-1209,30},{657,-1047,22},{462,-766,27},{171,-564,22},{621,-410,-1},{1136,-667,57},{988,-138,73},{1667,0,166},{2500,-390,95},{2549,385,108},{2618,1692,31},{1414,1162,114},{693,1201,345},{660,549,130},{219,97,97},{-141,234,99},{87,812,211},{-91,939,233},{-441,1596,358},{-58,1939,190},{-601,2088,132},{-300,2847,55},{63,3683,39},{543,3074,40},{387,2570,44},{852,2166,52},{1408,2157,98},{1189,2641,38},{1848,2700,63},{2635,2931,44},{2399,3063,54},{2394,3062,52},}
    for ID, coords in ipairs(figures) do
        figuresSub:add_click_option("#" .. ID, "#", function (option)
            features.teleport(Vector3(table.unpack(coords)))
            option:setTags({{"[Collected]",	0, 204, 255}})
        end)
    end
    Recovery:add_sub_option("Figures", "BS_Recovery_Collectibles_Figures", figuresSub)
end

local jammersSub = Submenu.add_static_submenu("Signal jammers", "BS_Recovery_Collectibles_Jammers") do
    local jammers = {{-3096,783,33},{-2273,325,195},{-1280,304,91},{-1310,-445,108},{-1226,-866,82},{-1648,-1125,29},{-686,-1381,24},{-265,-1897,54},{-988,-2647,89},{-250,-2390,124},{554,-2244,74},{978,-2881,33},{1586,-2245,130},{1110,-1542,55},{405,-1387,75},{-1,-1018,95},{-182,-589,210},{-541,-213,82},{-682,228,154},{-421,1142,339},{-296,2839,68},{753,2596,133},{1234,1869,92},{760,1263,444},{677,556,153},{220,224,168},{485,-109,136},{781,-705,47},{1641,-33,178},{2442,-383,112},{2580,444,115},{2721,1519,85},{2103,1754,138},{1709,2658,60},{1859,3730,116},{2767,3468,67},{3544,3686,60},{2895,4332,101},{3296,5159,29},{2793,5984,366},{1595,6431,32},{-119,6217,62},{449,5595,793},{1736,4821,60},{732,4099,37},{-492,4428,86},{-1018,4855,301},{-2206,4299,54},{-2367,3233,103},{-1870,2069,154},
    }
    for ID, coords in ipairs(jammers) do
        jammersSub:add_click_option("#" .. ID, "#", function (option)
            features.teleport(Vector3(table.unpack(coords)))
            option:setTags({{"[Collected]",	0, 204, 255}})
        end):setHint("Enable NoClip before. You have to explode\nthe jammer by yourself.")
    end
    Recovery:add_sub_option("Signal jammers", "BS_Recovery_Collectibles_Jammers", jammersSub)
end

local cardsSub = Submenu.add_static_submenu("Cards", "BS_Recovery_Collectibles_Cards") do
    local cards = {{-1028,-2747,14},{-74,-2005,18},{202,-1645,29},{120,-1298,29},{11,-1102,29},{-539,-1279,27},{-1205,-1560,4},{-1288,-1119,7},{-1841,-1235,13},{-1155,-528,31},{-1167,-234,37},{-971,104,55},{-1513,-105,54},{-3048,585,7},{-3150,1115,20},{-1829,798,138},{-430,1214,325},{-409,585,125},{-103,368,112},{253,215,106},{-168,-298,40},{183,-686,43},{1131,-983,46},{1159,-317,69},{548,-190,54},{1487,1128,114},{730,2514,73},{188,3075,43},{-288,2545,75},{-1103,2714,19},{-2306,3388,31},{-1583,5204,4},{-749,5599,41},{-283,6225,31},{99,6620,32},{1876,6410,46},{2938,5325,101},{3688,4569,25},{2694,4324,45},{2120,4784,40},{1707,4920,42},{727,4189,41},{-524,4193,193},{79,3704,41},{900,3557,33},{1690,3588,35},{1991,3045,47},{2747,3465,55},{2341,2571,47},{2565,297,108},{1325,-1652,52},{989,-1801,31},{827,-2159,29},{810,-2979,6},}
    for ID, coords in ipairs(cards) do
        cardsSub:add_click_option("#" .. ID, "#", function (option)
            features.teleport(Vector3(table.unpack(coords)))
            option:setTags({{"[Collected]",	0, 204, 255}})
        end):setHint("You have to move a bit to collect it.")
    end
    Recovery:add_sub_option("Cards", "BS_Recovery_Collectibles_Cards", cardsSub)
end

require("BoolyScript/pages/recovery-v2/init")
