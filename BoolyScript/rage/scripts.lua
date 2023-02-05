local raw = {
    globals = {
        otrState = {
            playerInfo = 2657589,
            playerInfo_size = 466,
            offTheRadarOffset = 210,
        }
    },
    events = {
        forcePlayerIntoVeh = {
            event = 891653640
        },
        massiveWhileCrash = {
            event = -992162568,
            args = {math.random(2000000000, 2147483647)}
        },
        notificationsFull = {
            -421898791,
            2017408112,
            79966559,
            -1764855587,
            -1316587068,
            1724500641,
            1497062168,
            1130071994,
            -2004889829,
            1559364338,
            -133974622,
            -406997534,
            686299542,
            -1032040118,
            -28878294,
            -1197151915,
            1480097843,
            -344016925,
            -374020833,
            -1178166860,
            572419745,
            433001113,
            729651888,
            651491550,
            53100515,
            -1495761793,
            1856797497,
            -1131682040,
            -1947106202,
            908559907,
            1234308928,
            1940316911,
            -1265189073,
            -1791264630,
            -1875928609,
            -1379183386,
            -616828629,
            959808021,
            1510188247,
            134169308,
            928249011,
            -851799902,
            1358494362,
            390906319,
            373093524,
            -1433716817,
            1571819430,
            415967752,
            925621380,
            -1344240446,
            -1115664940,
            119705347,
            745744060,
            625977929,
            -1082301749,
            414496857,
            1769325206,
            2045065996,
            -1446607779,
            1757484042,
            -763952994,
            623198296,
            1751618454,
            2074119471,
            -2097031143,
            -432820279,
            1026229251,
            -812302864,
            1236709979,
            -1649806549,
            1770436139,
            2090123118,
            147071210,
            -677967046,
            -16645639,
            -1477239291,
            1322243116,
            -949779244,
            722107191,
            569076623,
            -360151775,
            -726825496,
            -388488748,
            1226355894,
            -1234628868,
            -841117686,
            -1446766503,
            1531912042,
            38375853,
            533603904,
            1550688975,
            288496205,
            125882680,
            1553561736,
            1504396077,
            -1387992064,
            -1610627141,
            264759403,
            229228123,
            -1838317397,
            1820622972,
            262753545,
            -162075004,
            218989605,
            -1075366243,
            -10456022,
            1882629798,
            -1891794136,
            704297910,
            -743620634,
            290596041,
            1239547822,
            111871813,
            -1162167396,
            1938205474,
            174278207,
            1704939268,
            -1434267229,
            654956208,
            -1884420507,
            -366858328,
            1587558688,
            -542998813,
            2124591694,
            496463391,
            -461983386,
            945692125,
            -2047135236,
            -1141159588,
            -1722940144,
            2095657940,
            -214249287,
            -1596713841,
            -507553632,
            -1346808195,
            532932991,
            -1218457646,
            1821738714,
            -832016399,
            -1903870031,
            -1288982703,
            1468751170,
            1891062979,
            1932093787,
            -974704311,
            -1606049106,
            631934828,
            -1719710261,
            -1786829919,
            -888530285,
            -1086641017,
            -319775187,
            -308331670,
            -1347981670,
            -2055268782,
            -586004863,
            1760415236,
            -503120183,
            1598143475,
            -1849487674,
            -599783702,
            -413897054,
            791844146,
            1446634808,
            -1388743393,
            1342908091,
            1991583693,
            -1308083776,
            -670839658,
            -833603091,
            -1339853976,
            -2006673237,
            -1969780944,
            1595722774,
            1378566556,
            1123367201,
            1827723759,
            1182963148,
            204738037,
            -2027497059,
            -1651984795,
            2016713093,
            -1356793128,
            413033397,
        }
    },
}

local scripts = {}
scripts.globals = {}

--KOSATKA
scripts.globals['kosatkaMain'] = 262145

scripts.globals['setKosatkaMissileCooldown'] = function(value)
    -- log.error("SCRIPTS", "\'setKosatkaMissileCooldown\' global hasn't been updated yet.")
    script_global:new(scripts.globals['kosatkaMain']):at(30187):set_float(value)
end

scripts.globals['setKosatkaMissileRange'] = function (value)
    -- log.error("SCRIPTS", "\'setKosatkaMissileRange\' global hasn't been updated yet.")
    script_global:new(scripts.globals['kosatkaMain']):at(30188):set_float(value)
end

--PLAYERS
scripts.globals['getPlayerOtr'] = function(pid)
    -- log.error("SCRIPTS", "\'getPlayerOtr\' global hasn't been updated yet.")
    -- return false
    return script_global:new(raw.globals.otrState.playerInfo):at(pid, raw.globals.otrState.playerInfo_size):at(raw.globals.otrState.offTheRadarOffset):get_long()
end

scripts.globals['skipCutscene'] = function()
    -- log.error("SCRIPTS", "\'skipCutscene\' global hasn't been updated yet.") 
    script_global:new(2766500):at(3):set_int64(1) -- CUTSCENE::REQUEST_CUTSCENE("HS4_SCP_KNCK", 8);
    script_global:new(1575060):set_int64(1) -- NETWORK::NETWORK_TRANSITION_ADD_STAGE
end

scripts.globals['removeTransactionError'] = function()
    --log.error("SCRIPTS", "\'removeTransactionError\' global hasn't been updated yet.")
    script_global:new(4536674):set_long(0)
    script_global:new(4536675):set_long(0)
    script_global:new(4536673):set_long(0)
end

scripts.globals["setInPersonalVehicle"] = function ()
    script_global:new(2639783):at(8):set_long(1)
end

scripts.globals["callGooch"] = function ()
    script_global:new(2756259):set_int64(6)
    script_global:new(2756261):set_int64(171)
end

scripts.events = {}

scripts.events['crash'] = function(pid)
    script.send(pid, raw.events.forcePlayerIntoVeh.event, 1, raw.events.massiveWhileCrash.args[1])
    script.send(pid, raw.events.massiveWhileCrash.event, 0, raw.events.massiveWhileCrash.args[1])
end

scripts.events['sendRandomNotif'] = function(pid)
    script.send(pid, raw.events.notificationsFull[math.random(1, #raw.events.notificationsFull)],
    math.random(-2147483647, 2147483647), 1, 0, 0, 0, 0, 0,
    math.random(0, 32), player.index(), math.random(0, 32), math.random(0, 32))
end

return scripts
