local raw = {
    globals = {
        otrState = {
            playerInfo = 2657589,
            playerInfo_size = 466,
            offTheRadarOffset = 210,
        },

    },
    events = {
        massiveWhileCrash = {
            event = -904555865,
            args = {math.random(2000000000, 2147483647)}
        }
    },
}

local scripts = {}
scripts.globals = {}

--KOSATKA
scripts.globals['kosatkaMain'] = 262145

scripts.globals['setKosatkaMissileCooldown'] = function(value)
    log.error("SCRIPTS", "\'setKosatkaMissileCooldown\' global hasn't been updated yet.")
    -- script_global:new(262145):at(29439):set_float(value)
end

scripts.globals['setKosatkaMissileRange'] = function (value)
    -- log.error("SCRIPTS", "\'setKosatkaMissileRange\' global hasn't been updated yet.")
    script_global:new(scripts.globals['kosatkaMain']):at(29440):set_float(value)
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
    script_global:new(4536673):set_long(0)
end

scripts.events = {}

scripts.events['crash'] = function(pid)
    --log.error("SCRIPTS", "\'crash\' SE hasn't been updated yet.")
    script.send(pid, raw.events.massiveWhileCrash.event, raw.events.massiveWhileCrash.args[1])
end

return scripts