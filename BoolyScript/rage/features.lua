local features = {}

function features.getWaypointCoords()
	if not HUD.IS_WAYPOINT_ACTIVE() then return end
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
    return HUD.GET_BLIP_COORDS(blip)
end

function features.getDistance(coords1, coords2, useZ)
    return math.sqrt((coords1.x - coords2.x)^2 + (coords1.y - coords2.y)^2 + (useZ and (coords1.z - coords2.z)^2 or 0))
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

function features.isPositionInArea(corner_leftUpper_v2, corner_rightDown_v2, position_v2)
	local axis_x_b = (position_v2.x >= corner_leftUpper_v2.x) and (corner_rightDown_v2.x >= position_v2.x)
	local axis_y_b = (position_v2.y >= corner_leftUpper_v2.y) and (corner_rightDown_v2.y >= position_v2.y)
	return axis_x_b and axis_y_b
end

function features.getVirtualKeyViaID(id)
	for name, keyID in pairs(gui.virualKeys) do
		if keyID == id then return name end
	end
	return nil
end

function features.getVirtualKeyState(id)
	local key_s = features.getVirtualKeyViaID(id)
	if not key_s then return nil end
	return Stuff.guiKeyState[key_s]
end

function features.teleport(...)
	local args = {...}
	local entity = nil
	local coords = nil
	if type(args[1]) == "number" and (#args == 4 or #args == 2) then
		if (#args == 2) then
			if not (type(args[2]) == "userdata") then log.error("Features", "Wrong arg #2 in teleport function.") return false end
			coords = args[2]
		elseif #args == 4 then
			if not ((type(args[2]) == "number") and (type(args[3]) == "number") and (type(args[4]) == "number")) then log.error("Features", "Wrong arg #2, 3, 4 in teleport function.") return false end
			coords = Vector3(args[2], args[3], args[4])
		end
		entity = args[1]
	elseif type(args[1]) == "userdata" and (#args == 1) then
		coords = args[1]
		entity = player.id()
	elseif (#args == 3) and (type(args[1]) == "number" and type(args[2]) == "number" and type(args[3]) == "number") then
		coords = Vector3(args[1], args[2], args[3])
		entity = player.id()
	end
	if entity and coords then
		local out = false
		callbacks.requestControl(entity, function ()
			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(entity, coords.x, coords.y, coords.z)
			out = true
		end)
		return out
	end
	return false
end

function table.tostring(table_t)
	local out = ""
	if #table_t == 0 then
		for key, value in pairs(table_t) do
			out = out .. string.format("['%s'] = %s, ", key, value)
		end
	else
		out = table.concat(table_t, ", ")
	end
	return out
end

function features.format(str, ...)
	local args = {...}
	local iterations = 0
	for _ in string.gmatch(str, "{}") do
		iterations = iterations + 1
		local out = args[iterations]
		if type(out) == 'table' then out = table.tostring(out) end
		str = str:gsub("{}", #args >= iterations and tostring(out) or "?", 1)
	end
	return str
end

function string.split(text_s, sep_s)
	if not sep_s then sep_s = " " end
	local out = {}
	local ID = 1
	out[ID] = ''
	for symbol in text_s:gmatch('.') do
		if symbol == sep_s then
      		ID = ID + 1
		  	out[ID] = ''
    	else
		  	out[ID] = out[ID] .. symbol
    	end
	end
	return out
end

function features.split_text_into_lines(text_s, maxWidth_n)
	local out = ""
	if draw.get_text_size(text_s).x <= maxWidth_n then return text_s end
	for _, token in ipairs(string.split(text_s, " ")) do
		local new = out .. token .. " "
		if draw.get_text_size(new).x > maxWidth_n then
			out = out .. '\n' .. token .. " "
		else
			out = new
		end
	end
	return out
end

return features