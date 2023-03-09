Model = {}

eEntityTypes = {
    ped = 1,
    vehicle = 2,
    object = 3,
}

function Model.register(hash_n, type_n)
    if not STREAMING.IS_MODEL_VALID(hash_n) then
        return log.error("Models", "Tried to register an invalid model with hash: {}", hash_n)
    end
    local self = {
        _hash = hash_n,
        _spawned = {},
        _type = type_n,
        _heading = nil,
        _coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player.id(), 0.0, 5.0, 0.0)
    }
    function self.setPos(vector3_t)
        self._coords = vector3_t
        return self
    end
    function self.setHeading(heading_n)
        self._heading = heading_n
        return self
    end
    function self.spawn(count_n)
        callbacks.requestModel(hash_n, function ()          
            switch (self._type, {
                [eEntityTypes.ped] = function ()
                    for i = 1, count_n or 1 do
                        table.insert(self._spawned, PED.CREATE_PED(0, self._hash, self._coords.x, self._coords.y, self._coords.z, self._heading or math.random(360), false, false))
                    end
                end,
                [eEntityTypes.vehicle] = function ()
                    for i = 1, count_n or 1 do
                        table.insert(self._spawned, VEHICLE.CREATE_VEHICLE(self._hash, self._coords.x, self._coords.y, self._coords.z, self._heading or math.random(360), true, true, false))
                    end
                end,
                [eEntityTypes.object] = function ()
                    for i = 1, count_n or 1 do
                        table.insert(self._spawned, OBJECT.CREATE_OBJECT(self._hash, self._coords.x, self._coords.y, self._coords.z, true, false, false))
                    end
                end
            })
        end)
        return self
    end
    function self.getSpawned(callback_f)
        if callback_f then callback_f(self._spawned, #self._spawned) end
        return self
    end
    function self.clear()
        for _, handle in ipairs(self._spawned) do
            entity.delete(handle)
        end
        self = nil
        return nil
    end
    return self
end