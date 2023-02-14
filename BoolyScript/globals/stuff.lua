Stuff = {
    ramps = {},
    bodyguards = {},
    ufos = {},
    attackers = {},
    isTextChatActive = false,
    blacklistedVehicles = {},
    onBlacklistedVehicle = function () end
}

ParsedFiles = {
    weapons = {},
    weaponHashes = {},
    peds = {},
    objects = {},
    vehicles = {},
}

Localizations = {
    russian = {},
    chinese = {},
    custom = {},
}

GetSelectedPlayer = function () end

draw.crop_text = function (text_s, len_n)
    if len_n <= 0 then return "" end
    if string.len(text_s) == 0 then return "" end
    if draw.get_text_size(text_s).x <= len_n then return text_s end
    return draw.crop_text(text_s:sub(1, -2), len_n)
end