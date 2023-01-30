local callbacks = {}

function callbacks.requestWepAsset(asset, onSuccess)
    local ticks = 0
    while ticks < 50 and not WEAPON.HAS_WEAPON_ASSET_LOADED(asset) do
        WEAPON.REQUEST_WEAPON_ASSET(asset, 31, 0)
        ticks = ticks + 1
    end
    if WEAPON.HAS_WEAPON_ASSET_LOADED(asset) then onSuccess() return end
end

function callbacks.requestControl(entity, onSuccess)
	local ticks = 0
    while ticks < 50 and not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
        ticks = ticks + 1
    end
    if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) then onSuccess(entity) return end
end

function callbacks.requestModel(hash, onSuccess)
	if not STREAMING.IS_MODEL_VALID(hash) then return end
	local tries = 0
	while tries < 50 and not STREAMING.HAS_MODEL_LOADED(hash) do
		STREAMING.REQUEST_MODEL(hash);
		tries = tries + 1
	end
	if STREAMING.HAS_MODEL_LOADED(hash) then onSuccess() return end
end

function callbacks.requestAnimDict(dict, onSuccess)
	if not STREAMING.DOES_ANIM_DICT_EXIST(dict) then 
		return 
	end
	local tries = 0
	while tries < 50 and not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
		STREAMING.REQUEST_ANIM_DICT(dict)
		tries = tries + 1
	end
	if STREAMING.HAS_ANIM_DICT_LOADED(dict) then onSuccess() return end
end

function callbacks.requestPtfxAsset(asset, onSuccess)
	local ticks = 0
	while ticks < 50 and not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(asset) do 
		STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)
		ticks = ticks + 1
	end
	if STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(asset) then onSuccess() return end
end

return callbacks