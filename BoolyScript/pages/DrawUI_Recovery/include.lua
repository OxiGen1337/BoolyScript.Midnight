local TRUE = true
local FALSE = false

local i2s = tostring

v2r = {}

local function packed_int(iParam0, iParam1, iParam2, iParam3)
	local iVar0
	local iVar1
	local uVar2

	if (iParam1 < 0)
	then
		iParam1 = 255
	end
	iVar0 = 0
	iVar1 = 0
	if (iParam0 >= 384 and iParam0 < 457)
	then
		iVar0 = STATS.GET_PACKED_INT_STAT_KEY((iParam0 - 384), 0, 1, iParam2)
		iVar1 = ((iParam0 - 384) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 384)) * 8) * 8
	
	elseif (iParam0 >= 457 and iParam0 < 513)
	then
		iVar0 = STATS.GET_PACKED_INT_STAT_KEY((iParam0 - 457), 1, 1, iParam2)
		iVar1 = ((iParam0 - 457) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 457)) * 8) * 8
	
	elseif (iParam0 >= 1281 and iParam0 < 1305)
	then
		iVar0 = STATS.GET_PACKED_INT_STAT_KEY((iParam0 - 1281), 0, 0, 0)
		iVar1 = ((iParam0 - 1281) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 1281)) * 8) * 8
	
	elseif (iParam0 >= 1305 and iParam0 < 1361)
	then
		iVar0 = STATS.GET_PACKED_INT_STAT_KEY((iParam0 - 1305), 1, 0, 0)
		iVar1 = ((iParam0 - 1305) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 1305)) * 8) * 8
	
	elseif (iParam0 >= 1393 and iParam0 < 2919)
	then
		iVar0 = STATS.GET_PACKED_TU_INT_STAT_KEY((iParam0 - 1393), 0, 1, iParam2)
		iVar1 = ((iParam0 - 1393) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 1393)) * 8) * 8
	
	elseif (iParam0 >= 1361 and iParam0 < 1393)
	then
		iVar0 = STATS.GET_PACKED_TU_INT_STAT_KEY((iParam0 - 1361), 0, 0, 0)
		iVar1 = ((iParam0 - 1361) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 1361)) * 8) * 8
	
	elseif (iParam0 >= 3879 and iParam0 < 4143)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 3879), 0, 1, iParam2, "_NGPSTAT_INT")
		iVar1 = ((iParam0 - 3879) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 3879)) * 8) * 8
	
	elseif (iParam0 >= 4143 and iParam0 < 4207)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 4143), 0, 0, 0, "_NGPSTAT_INT")
		iVar1 = ((iParam0 - 4143) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 4143)) * 8) * 8
	
	elseif (iParam0 >= 4399 and iParam0 < 6028)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 4399), 0, 1, iParam2, "_LRPSTAT_INT")
		iVar1 = ((iParam0 - 4399) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 4399)) * 8) * 8
	
	elseif (iParam0 >= 6413 and iParam0 < 7262)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 6413), 0, 1, iParam2, "_APAPSTAT_INT")
		iVar1 = ((iParam0 - 6413) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 6413)) * 8) * 8
	
	elseif (iParam0 >= 7262 and iParam0 < 7313)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 7262), 0, 1, iParam2, "_LR2PSTAT_INT")
		iVar1 = ((iParam0 - 7262) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 7262)) * 8) * 8
	
	elseif (iParam0 >= 7681 and iParam0 < 9361)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 7681), 0, 1, iParam2, "_BIKEPSTAT_INT")
		iVar1 = ((iParam0 - 7681) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 7681)) * 8) * 8
	
	elseif (iParam0 >= 9553 and iParam0 < 15265)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 9553), 0, 1, iParam2, "_IMPEXPPSTAT_INT")
		iVar1 = ((iParam0 - 9553) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 9553)) * 8) * 8
	
	elseif (iParam0 >= 15265 and iParam0 < 15369)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 15265), 0, 1, iParam2, "_GUNRPSTAT_INT")
		iVar1 = ((iParam0 - 15265) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 15265)) * 8) * 8
	
	elseif (iParam0 >= 16010 and iParam0 < 18098)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 16010), 0, 1, iParam2, "_DLCSMUGCHARPSTAT_INT")
		iVar1 = ((iParam0 - 16010) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 16010)) * 8) * 8
	
	elseif (iParam0 >= 18162 and iParam0 < 19018)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 18162), 0, 1, iParam2, "_GANGOPSPSTAT_INT")
		iVar1 = ((iParam0 - 18162) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 18162)) * 8) * 8
	
	elseif (iParam0 >= 19018 and iParam0 < 22066)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 19018), 0, 1, iParam2, "_BUSINESSBATPSTAT_INT")
		iVar1 = ((iParam0 - 19018) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 19018)) * 8) * 8
	
	elseif (iParam0 >= 22194 and iParam0 < 24962)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 22194), 0, 1, iParam2, "_ARENAWARSPSTAT_INT")
		iVar1 = ((iParam0 - 22194) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 22194)) * 8) * 8
	
	elseif (iParam0 >= 25538 and iParam0 < 26810)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 25538), 0, 1, iParam2, "_CASINOPSTAT_INT")
		iVar1 = ((iParam0 - 25538) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 25538)) * 8) * 8
	
	elseif (iParam0 >= 27258 and iParam0 < 28098)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 27258), 0, 1, iParam2, "_CASINOHSTPSTAT_INT")
		iVar1 = ((iParam0 - 27258) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 27258)) * 8) * 8
	
	elseif (iParam0 >= 28483 and iParam0 < 30227)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 28483), 0, 1, iParam2, "_SU20PSTAT_INT")
		iVar1 = ((iParam0 - 28483) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 28483)) * 8) * 8
	
	elseif (iParam0 >= 30483 and iParam0 < 30515)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 30483), 0, 1, iParam2, "_HISLANDPSTAT_INT")
		iVar1 = ((iParam0 - 30483) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 30483)) * 8) * 8
	
	elseif (iParam0 >= 7641 and iParam0 < 7681)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 7641), 0, 1, iParam2, "_NGDLCPSTAT_INT")
		iVar1 = ((iParam0 - 7641) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 7641)) * 8) * 8
	
	elseif (iParam0 >= 7313 and iParam0 < 7321)
	then
		iVar0 = STATS._GET_NGSTAT_INT_HASH((iParam0 - 7313), 0, 0, 0, "_NGDLCPSTAT_INT")
		iVar1 = ((iParam0 - 7313) - STATS._STAT_GET_PACKED_INT_MASK((iParam0 - 7313)) * 8) * 8
	end
	uVar2 = STATS.STAT_SET_MASKED_INT(iVar0, iParam1, iVar1, 8, iParam3)
	return uVar2
end

v2r['unlockAdminStuff'] = function(c)
    for i = 1, 31 do
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_ADMIN_CLOTHES_GV_BS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_ADMIN_CLOTHES_RM_BS_" .. i), -1, TRUE)
    end
    for i = 1, 3 do
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_ADMIN_WEAPON_GV_BS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_ADMIN_WEAPON_RM_BS_" .. i), -1, TRUE)
    end
	STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockClothes'] = function(c)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_BERD"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_DECL"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_FEET"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_HAIR"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_JBIB"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_LEGS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_OUTFIT"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_PROPS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_PROPS_10"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_PROPS_8"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_PROPS_9"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_SPECIAL"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_SPECIAL2"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_SPECIAL2_1"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_TEETH"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_TEETH_1"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_TEETH_2"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_TORSO"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_BERD"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_DECL"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_FEET"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_JBIB"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_LEGS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_OUTFIT"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_PROPS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_PROPS_10"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_PROPS_8"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_PROPS_9"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_SPECIAL"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_SPECIAL2"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_SPECIAL2_1"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_TEETH"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_TEETH_1"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_TEETH_2"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_TORSO"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_HAIR"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_JBIB"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_LEGS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_FEET"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_BERD"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_PROPS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_PROPS_8"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_PROPS_9"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_PROPS_10"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_OUTFIT"), -1, TRUE)
    for i = 1, 11 do
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CLOTHES_" .. i .. "_UNLCK"), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CLOTHES_" .. i .. "_OWNED"), -1, TRUE)
    end
    for i = 0, 205 do
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_DLC_APPAREL_ACQUIRED_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_DLC_APPAREL_USED_" .. i), -1, TRUE)
    end
    for i = 1, 7 do
    	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_SPECIAL_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_PROPS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_LEGS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_JBIB_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_HAIR_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_BERD_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_AVAILABLE_FEET_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_SPECIAL_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_PROPS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_LEGS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_JBIB_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_FEET_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_ACQUIRED_BERD_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_HAIR_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_JBIB_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_LEGS_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_FEET_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_BERD_" .. i), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CLTHS_USED_PROPS_" .. i), -1, TRUE)
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockTattoos'] = function(c)
    for i = 0, 45 do
    	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_TATTOO_FM_UNLOCKS_" .. i), -1, TRUE)
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockWeapons'] = function(c)
	for i = 1, 4 do
		STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_ADDON_" .. i .. "_UNLCK"), -1, TRUE)
		STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_WEAP_ADDON_" .. i .. "_UNLCK"), -1, TRUE)
		STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_WEAP_FM_ADDON_PURCH" .. i + 1), -1, TRUE)
	end
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_UNLOCKED"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_UNLOCKED2"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_WEAP_FM_ADDON_PURCH"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_PURCHASED"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_PURCHASED2"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_FM_PURCHASE"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_WEAP_FM_PURCHASE2"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_WEAP_ADDON_5_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_WEAP_UNLOCKED"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_WEAP_UNLOCKED2"), -1, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['health'] = function(c)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_HEALTH_1_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_HEALTH_2_UNLCK"), -1, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['awards'] = function(c)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_5STAR_WANTED_AVOIDANCE"), 50, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ACTIVATE_2_PERSON_KEY"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ALL_ROLES_HEIST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_BUY_EVERY_GUN"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CAR_BOMBS_ENEMY_KILLS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CARS_EXPORTED"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CONTROL_CROWDS"), 25, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJCOMPLETEDSA"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJCOMPLETED"), 100, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJMONTHBONUS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJWEEKBONUS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJWEEKBONUSSA"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DAILYOBJMONTHBONUSSA"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DO_HEIST_AS_MEMBER"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DO_HEIST_AS_THE_LEADER"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_COMPLETE_HEIST_NOT_DIE"), 50, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MATCHING_OUTFIT_HEIST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DRIVELESTERCAR5MINS"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DROPOFF_CAP_PACKAGES"), 100, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FINISH_HEIST_NO_DAMAGE"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FINISH_HEIST_SETUP_JOB"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FINISH_HEISTS"), 50, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM25DIFFERENTDM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM25DIFFERENTRACES"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM25DIFITEMSCLOTHES"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMFURTHESTWHEELIE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM6DARTCHKOUT"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_DM_3KILLSAMEGUY"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_DM_KILLSTREAK"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_DM_STOLENKILL"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_DM_TOTALKILLS"), 500, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_DM_WINS"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_GOLF_BIRDIES"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM_GOLF_HOLE_IN_1"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_GOLF_WON"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_GTA_RACES_WON"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_RACE_LAST_FIRST"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_RACES_FASTEST_LAP"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_SHOOTRANG_CT_WON"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM_SHOOTRANG_GRAN_WON"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_SHOOTRANG_RT_WON"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_SHOOTRANG_TG_WON"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TDM_MVP"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TDM_WINS"), 50, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TENNIS_5_SET_WINS"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TENNIS_ACE"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TENNIS_STASETWIN"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FM_TENNIS_WON"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMATTGANGHQ"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMBASEJMP"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMBBETWIN"), 50000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMCRATEDROPS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMDRIVEWITHOUTCRASH"), 30, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMFULLYMODDEDCAR"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMHORDWAVESSURVIVE"), 10, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMKILL3ANDWINGTARACE"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMKILLBOUNTY"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMKILLSTREAKSDM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMMOSTKILLSGANGHIDE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMMOSTKILLSSURVIVE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMPICKUPDLCCRATE1ST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMRACEWORLDRECHOLDER"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMRALLYWONDRIVE"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMRALLYWONNAV"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMREVENGEKILLSDM"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMSHOOTDOWNCOPHELI"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMTATTOOALLBODYPARTS"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINAIRRACE"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINALLRACEMODES"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINCUSTOMRACE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINEVERYGAMEMODE"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINRACETOPOINTS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FMWINSEARACE"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_HOLD_UP_SHOPS"), 20, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_KILL_CARRIER_CAPTURE"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_KILL_PSYCHOPATHS"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_KILL_TEAM_YOURSELF_LTS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_LAPDANCES"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_LESTERDELIVERVEHICLES"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_MENTALSTATE_TO_NORMAL"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_NIGHTVISION_KILLS"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_NO_HAIRCUTS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ODISTRACTCOPSNOEATH"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ONLY_PLAYER_ALIVE_LTS"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PARACHUTE_JUMPS_20M"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PARACHUTE_JUMPS_50M"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PASSENGERTIME"), 4, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PICKUP_CAP_PACKAGES"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_RACES_WON"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_SECURITY_CARS_ROBBED"), 25, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SPLIT_HEIST_TAKE_EVENLY"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_STORE_20_CAR_IN_GARAGES"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TAKEDOWNSMUGPLANE"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TIME_IN_HELICOPTER"), 4, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TRADE_IN_YOUR_PROPERTY"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_VEHICLES_JACKEDR"), 500, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WIN_AT_DARTS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WIN_CAPTURE_DONT_DYING"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WIN_CAPTURES"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WIN_GOLD_MEDAL_HEISTS"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WIN_LAST_TEAM_STANDINGS"), 50, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_COMPLET_HEIST_MEM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_COMPLET_HEIST_1STPER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_FLEECA_FIN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_HST_ORDER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_HST_SAME_TEAM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_HST_ULT_CHAL"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_HUMANE_FIN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_PACIFIC_FIN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_PRISON_FIN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_SERIESA_FIN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_GANGOPS_IAA"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_GANGOPS_SUBMARINE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_AWD_GANGOPS_MISSILE"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DANCE_TO_SOLOMUN"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DANCE_TO_TALEOFUS"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DANCE_TO_DIXON"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DANCE_TO_BLKMAD"), 100, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CLUB_DRUNK"), 200, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CLUB_COORD"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CLUB_HOTSPOT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CLUB_CLUBBER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_BEGINNER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIELD_FILLER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ARMCHAIR_RACER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_LEARNER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SUNDAY_DRIVER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_THE_ROOKIE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_BUMP_AND_RUN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GEAR_HEAD"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DOOR_SLAMMER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_HOT_LAP"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ARENA_AMATEUR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PAINT_TRADER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SHUNTER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_JOCK"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_WARRIOR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_T_BONE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MAYHEM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_WRECKER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CRASH_COURSE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ARENA_LEGEND"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PEGASUS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CONTACT_SPORT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_UNSTOPPABLE"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WATCH_YOUR_STEP"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TOWER_OFFENSE"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_READY_FOR_WAR"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_THROUGH_A_LENS"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_SPINNER"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_YOUMEANBOOBYTRAPS"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_MASTER_BANDITO"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_SITTING_DUCK"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CROWDPARTICIPATION"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_KILL_OR_BE_KILLED"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_MASSIVE_SHUNT"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_YOURE_OUTTA_HERE"), 200, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WEVE_GOT_ONE"), 50, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ARENA_WAGEWORKER"), 20000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TIME_SERVED"), 1000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TOP_SCORE"), 500000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_CAREER_WINNER"), 1000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MPPLY_AWD_FM_CR_DM_MADE"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP"), 10000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MPPLY_AWD_FM_CR_RACES_MADE"), 25, TRUE)
	STATS.STAT_SET_INT(string.joaat("MPPLY_AWD_FM_CR_MISSION_SCORE"), 100, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME1"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME2"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME3"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME4"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME5"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FIRST_TIME6"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ALL_IN_ORDER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SUPPORTING_ROLE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_LEADER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SURVIVALIST"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ODD_JOBS"), 50, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SCOPEOUT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CREWEDUP"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MOVINGON"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PROMOCAMP"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GUNMAN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SMASHNGRAB"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_INPLAINSI"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_UNDETECTED"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ALLROUND"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ELITETHEIF"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PRO"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SUPPORTACT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_SHAFTED"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_COLLECTOR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_DEADEYE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PISTOLSATDAWN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_TRAFFICAVOI"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CANTCATCHBRA"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_WIZHARD"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_APEESCAPE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MONKEYKIND"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_AQUAAPE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_KEEPFAITH"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_TRUELOVE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_NEMESIS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_FRIENDZONED"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PREPARATION"), 40, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ASLEEPONJOB"), 20, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_DAICASHCRAB"), 100000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_BIGBRO"), 40, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_SHARPSHOOTER"), 40, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_RACECHAMP"), 40, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_BATSWORD"), 1000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_COINPURSE"), 950000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_ASTROCHIMP"), 3000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_MASTERFUL"), 40000, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_KINGOFQUB3D"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_QUBISM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_QUIBITS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GODOFQUB3D"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GOFOR11TH"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ELEVENELEVEN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_INTELGATHER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_COMPOUNDINFILT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_LOOT_FINDER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MAX_DISRUPT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_THE_ISLAND_HEIST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GOING_ALONE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_TEAM_WORK"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_MIXING_UP"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PRO_THIEF"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_CAT_BURGLAR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ONE_OF_THEM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_GOLDEN_GUN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ELITE_THIEF"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PROFESSIONAL"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_HELPING_OUT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_COURIER"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_PARTY_VIBES"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_HELPING_HAND"), TRUE, TRUE) 
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_AWD_ELEVENELEVEN"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_LOSTANDFOUND"), 500000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_SUNSET"), 1800000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_TREASURE_HUNTER"), 1000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WRECK_DIVING"), 1000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_KEINEMUSIK"), 1800000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_PALMS_TRAX"), 1800000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_MOODYMANN"), 1800000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_FILL_YOUR_BAGS"), 200000000, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_AWD_WELL_PREPARED"), 50, TRUE)


    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockExclusiveContent'] = function()
    STATS.STAT_SET_INT(string.joaat("MPPLY_UNLOCK_EXCLUS_CONTENT"), -1, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockChallenges'] = function()
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_MELEECHLENGECOMPLETED"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_HEADSHOTCHLENGECOMPLETED"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MPPLY_NAVYREVOLVERCOMPLETED"), TRUE, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockFastRunPlusReload'] = function(c)
    for i = 1, 3 do
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_ABILITY_" .. i .. "_UNLCK"), -1, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_ABILITY_" .. i .. "_UNLCK"), -1, TRUE)
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockVehicleMods'] = function(c)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_1_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_2_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_3_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_4_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_5_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_6_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_CARMOD_7_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_VEHICLE_1_UNLCK"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_FM_VEHICLE_2_UNLCK"), -1, TRUE)
	for i = 1, 12 do
		STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_KIT_" .. i .. "_FM_UNLCK"), -1, TRUE)
	end
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_KIT_FM_PURCHASE"), -1, TRUE)
	for i = 2, 12 do
		STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CHAR_KIT_FM_PURCHASE" .. i), -1, TRUE)
	end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockXmas'] = function(c)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_XMAS_NORM_CLOTHES_SAVED"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_XMAS_NORM_CLOTHES_TOP"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_XMAS_NORM_CLOTHES_LOWERS"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_XMAS_NORM_CLOTHES_FEET"), -1, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_XMAS_NORM_CLOTHES_SPECIALS"), -1, TRUE)
    for i = 0, 16 do
        STATS.STAT_SET_INT(string.joaat("MPPLY_XMASLIVERIES" .. i), -1, TRUE)
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockValentines'] = function(c)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VALENTINES_REC_CLOTHES"), TRUE, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockMovieProps'] = function(c)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_MOVIE_PROPS_COLLECTED"), 10, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockPilotSchool'] = function(c)
    for i = 0, 9 do
        STATS.STAT_SET_INT(string.joaat("MPPLY_PILOT_SCHOOL_MEDAL_" .. i), -1, TRUE)
        STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_PILOT_ASPASSEDLESSON_" .. i), TRUE, TRUE)
        STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_PILOT_SCHOOL_MEDAL_" .. i), -1, TRUE)
    end
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockPropertyAccess'] = function(c)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_PLANE_ACCESS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_BOAT_ACCESS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_HELI_ACCESS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_DOES_PLAYER_HAVE_VEH_ACCESS"), TRUE, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockShotaro'] = function(c)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_CRDEADLINE"), 5, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['giveMusket'] = function(c)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_MUSKET_IN_POSSESSION"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_MUSKET_AQUIRED_AS_GIFT"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_MUSKET_FM_AMMO_BOUGHT"), 9999, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_MUSKET_FM_AMMO_CURRENT"), 9999, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['giveFirework'] = function(c)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_FIREWRK_IN_POSSESSION"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_FIREWRK_AQUIRED_AS_GIFT"), TRUE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_FIREWRK_FM_AMMO_BOUGHT"), 9999, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_FIREWRK_FM_AMMO_CURRENT"), 9999, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['removeMusket'] = function(c)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_MUSKET_IN_POSSESSION"), FALSE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_MUSKET_AQUIRED_AS_GIFT"), FALSE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_MUSKET_FM_AMMO_BOUGHT"), 0, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_MUSKET_FM_AMMO_CURRENT"), 0, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['removeFirework'] = function(c)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_FIREWRK_IN_POSSESSION"), FALSE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_FIREWRK_AQUIRED_AS_GIFT"), FALSE, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_FIREWRK_FM_AMMO_BOUGHT"), 0, TRUE)
	STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_FIREWRK_FM_AMMO_CURRENT"), 0, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockArmoredParagon'] = function(c)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_RSC_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_BWL_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_MTG_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_OIL_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_DEF_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_CS_FIN_SEEN"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CAS_VEHICLE_REWARD"), FALSE, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_VCM_FLOW_PROGRESS"), -1, TRUE)
    STATS.STAT_SET_INT(string.joaat("MP" .. i2s(c) .. "_VCM_STORY_PROGRESS"), -1, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CASINOPSTAT_BOOL0"), TRUE, TRUE)
    STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CASINOPSTAT_BOOL1"), TRUE, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockObjectives'] = function(c)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_RACE_MODDED_CAR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_DRIVE_RALLY"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_GTA_RACE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_FOOT_RACE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_TEAM_DM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_VEHICLE_DM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_MISSION_CONTACT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_A_PLAYLIST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_POINT_TO_POINT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_ONE_ON_ONE_DM"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PLAY_ONE_ON_ONE_RACE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_SURV_A_BOUNTY"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_SET_WANTED_LVL_ON_PLAY"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_GANG_BACKUP_GANGS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_GANG_BACKUP_LOST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_GANG_BACKUP_VAGOS"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_CALL_MERCENARIES"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_PHONE_MECH_DROP_CAR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_GONE_OFF_RADAR"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_FILL_TITAN"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_MOD_CAR_USING_APP"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_BUY_APPARTMENT"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_BUY_INSURANCE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_BUY_GARAGE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_ENTER_FRIENDS_HOUSE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_CALL_STRIPPER_HOUSE"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_CALL_FRIEND"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_SEND_FRIEND_REQUEST"), TRUE, TRUE)
	STATS.STAT_SET_BOOL(string.joaat("MP" .. i2s(c) .. "_CL_W_WANTED_PLAYER_TV"), TRUE, TRUE)
    STATS.STAT_SAVE(0, 0, 3, 0)
end

v2r['unlockExtra'] = function(c)
	packed_int(7315, 6, c, TRUE)
	packed_int(18981, 4, c, TRUE)
	packed_int(18988, 24, c, TRUE)
	packed_int(22032, 100, c, TRUE)
	packed_int(22050, 100, c, TRUE)
	packed_int(22051, 100, c, TRUE)
	packed_int(22052, 100, c, TRUE)
	packed_int(22053, 100, c, TRUE)
	packed_int(22054, 100, c, TRUE)
	packed_int(22055, 100, c, TRUE)
	packed_int(22056, 100, c, TRUE)
	packed_int(22057, 100, c, TRUE)
	packed_int(22058, 100, c, TRUE)
	packed_int(22063, 20, c, TRUE)
	STATS.STAT_SAVE(0, 0, 3, 0)
end

return v2r