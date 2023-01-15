local features = {}

function features.getWaypointCoords()
	if not HUD.IS_WAYPOINT_ACTIVE() then return end
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
    return HUD.GET_BLIP_COORDS(blip)
end

function features.getDistance(coords1, coords2, useZ)
    return MISC.GET_DISTANCE_BETWEEN_COORDS(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, useZ)
end

function features.setVehiclePreset(vehicle, preset)
	local modTypes = {
		["Spoilers"] = 0,
		["Front Bumper"] = 1,
		["Rear Bumper"] = 2,
		["Side Skirt"] = 3,
		["Exhaust"] = 4,
		["Frame"] = 5,
		["Grille"] = 6, 
		["Hood"] = 7,
		["Fender"] = 8,
		["Right Fender"] = 9,
		["Roof"] = 10,
		["Engine"] = 11,
		["Brakes"] = 12,
		["Transmission"] = 13, 
		["Horns"] = 14,
		["Suspension"] = 15, 
		["Armor"] = 16,
		["Front Wheels"] = 23,
		["Back Wheels"] = 24,
		["Plate Holders"] = 25,
		["Trim Design"] = 27,
		["Ornaments"] = 28,
		["Dial Design"] = 30,
		["Steering Wheel"] = 33,
		["Shifter Leavers"] = 34,
		["Plaques"] = 35,
		["Hydraulics"] = 38,
		["Livery"] = 48
	}
	local modTypesPower = {
		["Engine"] = 11,
		["Brakes"] = 12,
		["Transmission"] = 13,
		["Suspension"] = 15
	}
	local function getMaxMods(vehicle, modType)
		local val = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, modType)
		if val > 0 then
			return val - 1
		else
			return 0
		end
	end
	entity.request_control(vehicle, function()
		VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
		if preset == 1 then -- DEFAULT
			for _, modType in pairs(modTypes) do
				VEHICLE.SET_VEHICLE_MOD(vehicle, modType, 0, false)
			end
		elseif preset == 2 then -- RANDOM
			for _, modType in pairs(modTypes) do
				VEHICLE.SET_VEHICLE_MOD(vehicle, modType, math.random(0, getMaxMods(vehicle, modType)), false)
				VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, math.random(0, 1))
			end
		elseif preset == 3 then -- POWER
			for _, modType in pairs(modTypesPower) do
				VEHICLE.SET_VEHICLE_MOD(vehicle, modType, getMaxMods(vehicle, modType), false)
				VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
			end
		elseif preset == 4 then -- MAX
			for _, modType in pairs(modTypes) do
				VEHICLE.SET_VEHICLE_MOD(vehicle, modType, getMaxMods(vehicle, modType), false)
				VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
			end
		end
	end)
end

function features.isEmpty(value)
	return ((value == nil) or (value == "") or (value == "NULL"))
end

function features.makeFirstLetUpper(text)
	local output = ''
	local iter = 0
	for let in text:gmatch('%D') do
		if iter == 0 then
			let = let:upper()
		end
		output = output .. let
		iter = iter + 1
	end
	return output
end

function features.getFPS()
	return DrawUI.dbg.fps
end

return features