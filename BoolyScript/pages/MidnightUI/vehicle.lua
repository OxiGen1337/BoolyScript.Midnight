require("BoolyScript/util/menu")
local callbacks = require("BoolyScript/rage/callbacks")
require("BoolyScript/util/notify_system")
local gui = require("BoolyScript/globals/gui")
require("BoolyScript/system/events_listener")
local features = require("BoolyScript/rage/features")

local page = GET_PAGES()['BS_Main']
local self = menu.add_mono_block(page, "Vehicle", "BS_Vehicle", BLOCK_ALIGN_RIGHT)

local function vehicleCheck()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    return (ENTITY.DOES_ENTITY_EXIST(vehicle) and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false))
end

menu.add_combo(self, "Switch seat", "BS_Vehicle_SwitchSeat", {"Driver", "Co-Driver", "Left Back Passanger", "Right Back Passanger"}, function (_, pos)
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
	PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, pos-2)
end)

menu.add_static_text(self, "Movement", "BS_Vehicle_Movement")

menu.add_looped_option(self, "Engine always on", "BS_Vehicle_Movement_EngineAlwOn", 0.0, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
    VEHICLE.SET_VEHICLE_LIGHTS(vehicle, 0)
    VEHICLE._SET_VEHICLE_LIGHTS_MODE(vehicle, 2)
end)

menu.add_checkbox(self, "The Crew 2 nitro", "BS_Vehicle_Movement_Crew2Nitro", function (_, state)
    local taskName = "BS_Vehicle_Movement_Crew2Nitro"
    if state then
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if not vehicleCheck() then return end
            if key ~= gui.keys.X then return end
            if isDown then
                if not task.exists(taskName) then 
                    local state = false
                    task.createTask(taskName, 2.0, 2, function ()
                        local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
                        local speed = GET_OPTIONS().num["BS_Vehicle_Movement_Crew2NitroPower"]:getValue() + .0
                        if state then
                            VEHICLE._SET_VEHICLE_NITRO_ENABLED(vehicle, false, 2500.0, speed, 999999999999999999.0, false)
                            state = not state
                        else
                            callbacks.requestPtfxAsset("veh_xs_vehicle_mods", function()				
                                VEHICLE._SET_VEHICLE_NITRO_ENABLED(vehicle, true, 2500.0, speed, 999999999999999999.0, false)
                                state = not state
                            end)
                        end
                    end)
                end
            end
        end)
    elseif listener.exists(taskName, GET_EVENTS_LIST().OnKeyPressed) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed)
    end
end)

menu.add_slider_int(self, "Nitro power", "BS_Vehicle_Movement_Crew2NitroPower", 1, 25):set(5)

menu.add_checkbox(self, "Cruise control", "BS_Vehicle_Movement_CruiseControl", function (_, state)
    local taskName = "BS_Vehicle_Movement_CruiseControl"
    if state then
        local isActive = false
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if not vehicleCheck() then return end
            if key ~= gui.keys.L then return end
            if isDown then
                isActive = not isActive
                if isActive then
                    if not task.exists(taskName) then 
                        local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
                        local speedToKeep = ENTITY.GET_ENTITY_SPEED(vehicle, true)
                        task.createTask(taskName, 0.0, nil, function ()
                            local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
                            if VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) and not ENTITY.IS_ENTITY_IN_AIR(vehicle) then 
                                local speed = speedToKeep
                                local multiplier = 1
                                if ENTITY.GET_ENTITY_SPEED_VECTOR(vehicle, true).y < 0 then multiplier = -1 end
                                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed*multiplier)
                            end 
                        end)
                        notify.success("Vehicle", string.format("Cruise control is enabled.\nSpeed to keep: %f\n", speedToKeep), GET_NOTIFY_ICONS().vehicle)
                    end
                elseif task.exists(taskName) then
                    task.removeTask(taskName)
                    notify.success("Vehicle", "Cruise control is disabled.", GET_NOTIFY_ICONS().vehicle)
                end
            end
        end)
    elseif listener.exists(taskName, GET_EVENTS_LIST().OnKeyPressed) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed)
    end
end)

menu.add_looped_option(self, "Disable turbulence", "BS_Vehicle_Movement_DisableTurbulence", 0.0, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
    if class ~= 15 then return end
    VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(vehicle, 0.0)
end)

menu.add_looped_option(self, "Disable gravity", "BS_Vehicle_Movement_DisableGravity", 0.0, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    VEHICLE.SET_VEHICLE_GRAVITY(vehicle, false)
end, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    VEHICLE.SET_VEHICLE_GRAVITY(vehicle, true)
end)

menu.add_looped_option(self, "Disable collision for aircraft", "BS_Vehicle_Movement_DisableAircraftCollision", 0.0, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
    if class ~= 15 and class ~= 16 then return end
    ENTITY.SET_ENTITY_COLLISION(vehicle, false, true)
end, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    ENTITY.SET_ENTITY_COLLISION(vehicle, true, true)
end)


menu.add_checkbox(self, "Super drive [W]", "BS_Vehicle_Movement_SuperDrive", function (_, state)
    local taskName = "BS_Vehicle_Movement_SuperDrive"
    if state then
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if not (key == gui.keys.W) then return end
            if isDown then
                task.createTask(taskName, 0.0, nil, function ()
                    if not vehicleCheck() then return end
                    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
                    local multiplier = GET_OPTIONS().sliderFloat['BS_Vehicle_Movement_SuperDrivePower']:get()
                    ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 9999.0)
                    entity.request_control(vehicle, function(handle)
                        ENTITY.APPLY_FORCE_TO_ENTITY(handle, 1, 0.0, multiplier / 10.0, 0.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end)
                end)
            elseif task.exists(taskName) then
                task.removeTask(taskName)
            end
        end)
    elseif listener.exists(taskName, GET_EVENTS_LIST().OnKeyPressed) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed)
    end
end)

menu.add_slider_float(self, "Super drive power", "BS_Vehicle_Movement_SuperDrivePower", 1.0, 30.0):set(5.0)

menu.add_static_text(self, "Appearance", "BS_Vehicle_Appeearance")

menu.add_checkbox(self, "Use countermeasures", "BS_Vehicle_Appeearance_UseCounters", function (_, state)
    local taskName = "BS_Vehicle_Appeearance_UseCounters"
    if state then
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if key ~= gui.keys.E then return end
            if isDown then
                task.createTask(taskName, 0.3, nil, function ()
                    if not vehicleCheck() then return end
                    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
                    WEAPON.GIVE_WEAPON_TO_PED(PLAYER.PLAYER_PED_ID(), string.joaat("WEAPON_FLAREGUN"), 20, true, false)
                    
                    local offset = {}
                    offset.rightStart = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, -2.0, -2.0, 0.0)
                    offset.rightEnd = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, -30.0, -40.0, -10.0)
                    offset.leftStart = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 2.0, -2.0, 0.0)
                    offset.leftEnd = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 30.0, -40.0, -10.0)
                    
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(offset.rightStart.x, offset.rightStart.y, offset.rightStart.z, offset.rightEnd.x, offset.rightEnd.y, offset.rightEnd.z, 0, true, 1198879012, PLAYER.PLAYER_PED_ID(), true, false, 1)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(offset.leftStart.x, offset.leftStart.y, offset.leftStart.z, offset.leftEnd.x, offset.leftEnd.y, offset.leftEnd.z, 0, true, 1198879012, PLAYER.PLAYER_PED_ID(), true, false, 1)
                end)
            elseif task.exists(taskName) then
                task.removeTask(taskName)
            end
        end)
    elseif listener.exists(taskName, GET_EVENTS_LIST().OnKeyPressed) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed)
    end
end)

menu.add_checkbox(self, "Use vehicle signals", "BS_Vehicle_Appeearance_UseVehicleSignals", function (_, state)
    local taskName = "BS_Vehicle_Appeearance_UseVehicleSignals"
    local keys = gui.keys    
    if state then
        local right, left = false, false
        listener.register(taskName, GET_EVENTS_LIST().OnKeyPressed, function (key, isDown)
            if not vehicleCheck() then return end
            if key ~= keys.ArrowLeft and key ~= keys.ArrowRight and key ~= keys.E then return end
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
            
            if key == keys.ArrowLeft then
                if isDown then
                    left = not left
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, left)
                end
            end
            if key == keys.ArrowRight then
                if isDown then
                    right = not right
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, right)
                end
            end
            if key == keys.E then
                local mult = 1.0
                if isDown then mult = 6.0 end
                VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(vehicle, mult)
            end
        end)
    elseif listener.exists(taskName, GET_EVENTS_LIST().OnKeyPressed) then
        listener.remove(taskName, GET_EVENTS_LIST().OnKeyPressed) 
    end
end)

menu.add_looped_option(self, "Disable deformations", "BS_Vehicle_Appeearance_DisableDeformations", 0.0, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
    VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(vehicle, false)
end, function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(vehicle, true)
end)

local doors = {
    "Front left",
    "Front right", 
    "Back left",
    "Back right",
    "Hood",
    "Trunk",
    "Back",
    "Back 2"
}

local doorsSelector = menu.add_combo(self, "Doors", "BS_Vehicle_Appeearance_Doors", doors)

menu.add_button(self, "Open door", "BS_Vehicle_Appeearance_OpenDoor", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local door = doorsSelector:get() 
    VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, door, false, true)
end)

menu.add_button(self, "Close door", "BS_Vehicle_Appeearance_CloseDoor", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local door = doorsSelector:get() 
    VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, door, false, true)
end)

menu.add_button(self, "Open all doors", "BS_Vehicle_Appeearance_OpenAllDoors", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    for index, _ in ipairs(doors) do
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, index-1, false, true)
    end 
end)

menu.add_button(self, "Close all doors", "BS_Vehicle_Appeearance_CloseAllDoors", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    for index, _ in ipairs(doors) do
        VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, index - 1, false, true)
    end 
end)

menu.add_static_text(self, "Remote actions", "BS_Vehicle_RemoteActions")

menu.add_button(self, "Teleport (Me -> Vehicle)", "BS_Vehicle_RemoteActions_TpMeToVehicle", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local coords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
    utils.teleport(coords)
end)

menu.add_button(self, "Teleport (Vehicle -> Me)", "BS_Vehicle_RemoteActions_TpVehicleToMe", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    utils.teleport(vehicle, coords)
end)

menu.add_button(self, "Toggle engine", "BS_Vehicle_RemoteActions_ToggleEngine", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    entity.request_control(vehicle, function(handle)
        VEHICLE.SET_VEHICLE_ENGINE_ON(handle, not VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(handle), true, true)
        VEHICLE.SET_VEHICLE_LIGHTS(handle, 0)
        VEHICLE._SET_VEHICLE_LIGHTS_MODE(handle, 0)
    end)
end)

menu.add_button(self, "Enable alarm (30 sec)", "BS_Vehicle_RemoteActions_EnableAlarm", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    entity.request_control(vehicle, function(handle)	
        VEHICLE.SET_VEHICLE_ALARM(handle, true)
        VEHICLE.START_VEHICLE_ALARM(handle)
    end)
end)

menu.add_button(self, "Repair vehicle", "BS_Vehicle_RemoteActions_RepairVehicle", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    entity.request_control(vehicle, function(handle)
        VEHICLE.SET_VEHICLE_FIXED(handle)
    end)
end)

menu.add_button(self, "Explode vehicle", "BS_Vehicle_RemoteActions_ExplodeVehicle", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    entity.request_control(vehicle, function(handle)
        VEHICLE.EXPLODE_VEHICLE_IN_CUTSCENE(handle, true)
    end)
end)

menu.add_checkbox(self, "Invert controls", "BS_Vehicle_RemoteActions_InvertControls", function (_, state)
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    entity.request_control(vehicle, function(handle)
        VEHICLE._SET_VEHICLE_CONTROLS_INVERTED(handle, state)
    end)
end)

menu.add_button(self, "Delete vehicle", "BS_Vehicle_RemoteActions_DeleteVehicle", function ()
    if not vehicleCheck() then return end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    if PED.IS_PED_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, false) then
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
    end
    entity.delete(vehicle)
end)

-- END