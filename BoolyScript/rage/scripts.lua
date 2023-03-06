--creds: kektram for some events

local raw = {
    globals = {
        otrState = {
            playerInfo = 2657589,
            playerInfo_size = 466,
            offTheRadarOffset = 210,
        }
    },
    events = {
        passiveMode = {
            event = 547789403
        },
        forcePlayerIntoVeh = {
            event = 891653640
        },
        massiveWhileCrash = {
            event = -992162568,
            event2 = 1466468442,
            args = {math.random(2000000000, 2147483647)}
        },
        notifCrash = {
            event = 1466468442,
        },
        notifKick = {
            event = -578649573,
        },
        notificationsFull = {
            452938553,
            -51629183,
            1831867170,
            -1896366254,
            -1769219339,
            -1201829147,
            -1517442370,
            133276031,
            747596633,
            1347638234,
            1440461450,
            -1885238681,
            -1674949541,
            276906331,
            82080686,
            853249803,
            -617191610,
            -545057654,
            2048922946,
            -1481848857,
            1654394662,
            -1770347024,
            -859396924,
            927356288,
            -1871245691,
            -1891585544,
            -1497171835,
            -91279174,
            323140324,
            156120852,
            -125529465,
            -856002885,
            1866254059,
            1992879396,
            -506195839,
            536247389,
            40415436,
            693212712,
            -2072720249,
            -2023529582,
            -680281595,
            -162862366,
            1692486872,
            -46327943,
            1551613046,
            826814496,
            -206369507,
            215994989,
            -1767294187,
            1105683428,
            825274629,
            -1422778765,
            -1446638030,
            -437005646,
            1205553315,
            1715399868,
            1054826091,
            -171231893,
            905090366,
            -1492151242,
            -233807788,
            799644743,
            -767364034,
            1594775632,
            -946271051,
            -788575836,
            -1358816432,
            -1054388735,
            -264618765,
            -1221660330,
            -236682200,
            -239271415,
            -1364562129,
            -240186045,
            1313302519,
            1267118853,
            117293314,
            934722448,
            -1839517426,
            841444579,
            146109770,
            -427075079,
            -383917759,
            -1865943047,
            1151073857,
            -782545562,
            -607688663,
            -94996696,
            1992015606,
            858711231,
            1340945314,
            1660662958,
            1033324347,
            -1712231292,
            1532951285,
            1534835942,
            1417675950,
            -323581143,
            1435651751,
            445772363,
            -307630570,
            -811897066,
            -255033312,
            -1289092281,
            38143317,
            -1783618453,
            1624963287,
            1194877609,
            776020967,
            -1354982652,
            1883642286,
            -1649344278,
            674607575,
            -1045393704,
            230380648,
            809823027,
            -534374271,
            -1143278454,
            829500279,
            -817438578,
            -1175819830,
            1069804344,
            1853971215,
            1277940407,
            747436217,
            -322595501,
            1588666147,
            1086389994,
            -1036402456,
            -865648130,
            451971127,
            -1763559476,
            1377514326,
            -1388824359,
            -224985215,
            244034214,
            -368990008,
            -461851137,
            835963447,
            -2029707091,
            -919994634,
            -1017535732,
            -1780664096,
            -1055343339,
            -527208501,
            2021477031,
            -112973257,
            -1431844264,
            -429114273,
            -909938777,
            -1629549027,
            776366923,
            -1331596270,
            -1069537481,
            1459140562,
            1197543335,
            89553090,
            -1858635130,
            -2030849211,
            548541714,
            560275391,
            -1856120941,
            -1868161678,
            -904876187,
            -1492242492,
            1302312272,
            -80563138,
            1323981595,
            -1350471532,
            446019400,
            -1624737755,
            2082207978,
            1602147982,
            1554197302,
            -1744981281,
            1145256297,
            1140260160,
            -1775372182,
            -1306903600,
            891899079,
            1354665487,
            -2051461174,
            153865685,
            1713623606
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

scripts.globals['getCharId'] = function()
    -- log.error("SCRIPTS", "\'getCharId\' global hasn't been updated yet.")
    -- return false
    return script_global:new(1574918):get_long()
end

scripts.globals['getCharIdStr'] = function()
    return tostring("MP" .. scripts.globals.getCharId() .. "_")
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

scripts.events['notifCrash'] = function(pid)
    script.send(pid, raw.events.notifCrash.event,
    math.random(-2147483647, 2147483647), 1, 0, 0, 0, 0, 0, pid,
    player.index(), features.randomPlayer(), features.randomPlayer())
end

scripts.events['notifKick'] = function(pid)
    script.send(pid, raw.events.notifKick.event, pid, math.random(-2147483647, 2147483647))
end

scripts.events['passiveMode'] = function(pid, state)
    script.send(pid, raw.events.passiveMode.event, pid, state)
end

scripts.events['sendRandomNotif'] = function(pid)
    script.send(pid, raw.events.notificationsFull[math.random(1, #raw.events.notificationsFull)],
    math.random(-2147483647, 2147483647), 1, 0, 0, 0, 0, 0, pid,
    player.index(), features.randomPlayer(), features.randomPlayer())
end

return scripts
