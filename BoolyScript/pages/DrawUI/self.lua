Self = Submenu.add_static_submenu("Self", "BS_Self_Submenu")
Main:add_sub_option("Self", "BS_Self_SubOption", Self)

local godmode = Submenu.add_static_submenu("Invincibility", "BS_Self_Godmode_Submenu") do
    godmode:add_bool_option("Godmode", "BS_Self_Godmode_Enable", function (state)
        ENTITY.SET_ENTITY_INVINCIBLE(PLAYER.PLAYER_PED_ID(), state)
    end)
    godmode:add_separator("Detailed", "BS_Self_Godmode_Detailed")
    local proofs = {
        ["Bullet"] = false,
        ["Fire"] = false,
        ["Explosion"] = false,
        ["Collision"] = false,
        ["Melee"] = false,
        ["Steam"] = false,
    }
    godmode:add_bool_option("Enable", "BS_Self_Godmode_Detailed_Enable", function (state)
        if state then 
            task.createTask("BS_Self_Godmode_Detailed", 0.0, nil, function ()
                ENTITY.SET_ENTITY_PROOFS(PLAYER.PLAYER_PED_ID(), proofs.Bullet, proofs.Fire, proofs.Explosion, proofs.Collision, proofs.Melee, proofs.Steam, false, false)
            end)
        elseif task.exists("BS_Self_Godmode_Detailed") then
            task.removeTask("BS_Self_Godmode_Detailed")
        end
    end)
    for name, _ in pairs(proofs) do
        godmode:add_bool_option(name, "BS_Self_Godmode_Detailed_" .. name, function (state)
            proofs[name] = state
        end)
    end
    Self:add_sub_option("Invincibility", "BS_Self_Godmode_SubOption", godmode)
end

local wardrobe = Submenu.add_static_submenu("Wardrobe", "BS_Self_Wardrobe_Submenu") do
    wardrobe:add_sub_option("Save & load outfit presets", "BS_Self_Wardrobe_SaveLoad", PresetsMgr):addTag({"[Link]", 107, 223, 227})
    wardrobe:add_separator("Face", "BS_Self_Wardrobe_Face")
    local headBlendEditor = Submenu.add_static_submenu("Face editor", "BS_Self_Wardrobe_HeadBlend_Submenu") do
        headBlendEditor:add_separator("Head blend", "BS_Self_Wardrobe_HeadBlend")
        local motherShape, motherSkin, fatherShape, fatherSkin, shapeMix, skinMix
        motherShape = headBlendEditor:add_choose_option("Shape [Mother]", "BS_Self_Wardrobe_HeadBlend_MotherShape", true,
            {"Anthony", "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Claude", "Niko", "John", "Misty"},
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        fatherShape = headBlendEditor:add_choose_option("Shape [Father]", "BS_Self_Wardrobe_HeadBlend_FatherShape", true,
            {"Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel"},
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        shapeMix = headBlendEditor:add_float_option("Shape mix (Mother->Father)", "BS_Self_Wardrobe_HeadBlend_ShapeMix", 0.0, 1.0, 0.1,
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        motherSkin = headBlendEditor:add_choose_option("Skin [Mother]", "BS_Self_Wardrobe_HeadBlend_MotherSkin", true,
            {"Anthony", "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Claude", "Niko", "John", "Misty"},
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        fatherSkin = headBlendEditor:add_choose_option("Skin [Father]", "BS_Self_Wardrobe_HeadBlend_FatherSkin", true,
            {"Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel"},
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        skinMix = headBlendEditor:add_float_option("Skin mix (Mother->Father)", "BS_Self_Wardrobe_HeadBlend_SkinMix", 0.0, 1.0, 0.1,
            function ()
                PED.SET_PED_HEAD_BLEND_DATA(player.id(), motherShape:getValue(), fatherShape:getValue(), 0, motherSkin:getValue(), fatherSkin:getValue(), 0, shapeMix:getValue(), skinMix:getValue(), 0.0, true)
            end
        ):setConfigIgnore()
        headBlendEditor:add_separator("Face", "BS_Self_Wardrobe_Face")
        local overlayIDs = {
            {"Blemishes", 23, 0},
            {"Facial Hair", 28, 1},
            {"Eyebrows", 33, 1},
            {"Ageing", 14, 0},
            {"Makeup", 74, 0},
            {"Blush", 6, 2},
            {"Complexion", 11, 0},
            {"Sun Damage", 10, 0},
            {"Lipstick", 9, 2},
            {"Moles/Freckles", 17, 0},
            {"Chest Hair", 16, 1},
            {"Body Blemishes", 11, 0},
            {"Add Body Blemishes", 1, 0},
        }
        for ID, overlay in ipairs(overlayIDs) do
            local submenu = Submenu.add_static_submenu(overlay[1], "BS_Self_Wardrobe_Face_" .. overlay[1] .. "_Submenu") do
                local value = submenu:add_num_option("Texture", "BS_Self_Wardrobe_Face_" .. overlay[1], 0, overlay[2], 1, function (val)
                    PED.SET_PED_HEAD_OVERLAY(player.id(), ID - 1, val, 1.0)
                end):setConfigIgnore()
                local opacity = submenu:add_float_option("Opacity", "BS_Self_Wardrobe_Face_Opacity_" .. overlay[1], 0.0, 1.0, 0.1, function (val)
                    PED.SET_PED_HEAD_OVERLAY(player.id(), ID - 1, value:getValue(), val)
                end):setValue(1.0, true):setConfigIgnore()
                local primColor, secColor
                primColor = submenu:add_num_option("Primary color",  "BS_Self_Wardrobe_Face_PrimColor_" .. overlay[1], 0, 255, 1, function (val)
                    PED.SET_PED_HEAD_OVERLAY(player.id(), ID - 1, value:getValue(), opacity:getValue())
                    PED._SET_PED_HEAD_OVERLAY_COLOR(player.id(), ID-1, overlay[3], val, secColor:getValue())                
                end):setConfigIgnore()
                secColor = submenu:add_num_option("Secondary color",  "BS_Self_Wardrobe_Face_SecColor_" .. overlay[1], 0, 255, 1, function (val)
                    PED.SET_PED_HEAD_OVERLAY(player.id(), ID - 1, value:getValue(), opacity:getValue())
                    PED._SET_PED_HEAD_OVERLAY_COLOR(player.id(), ID-1, overlay[3], primColor:getValue(), val)                
                end):setConfigIgnore()
                submenu:add_click_option("Remove", "BS_Self_Wardrobe_Face_Remove_" .. overlay[1], function ()
                    PED.SET_PED_HEAD_OVERLAY(player.id(), ID - 1, 255, 1.0)
                end)
                headBlendEditor:add_sub_option(overlay[1], "BS_Self_Wardrobe_Face_" .. overlay[1] .. "_SubOption", submenu)
            end
        end
        wardrobe:add_sub_option("Face", "BS_Self_Wardrobe_HeadBlend_SubOption", headBlendEditor)
    end
    wardrobe:add_separator("Accessories", "BS_Self_Wardrobe_Accessories")
    local props = {
        ["Hats"] = 0,
        ["Glasses"] = 1,
        ["Ears"] = 2,
    }
    for name, ID in pairs(props) do
        local ped = PLAYER.PLAYER_PED_ID()
        local submenu = Submenu.add_static_submenu(name, "BS_Self_Wardrobe_" .. name .."_Submenu")
        local drawableVariations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(ped, ID)
        local textures
        local variations = submenu:add_num_option("Variation", "BS_Self_Wardrobe_" .. name .."_Variation", 0, drawableVariations - 1, 1, function (val)
            local ped = PLAYER.PLAYER_PED_ID()
            PED.SET_PED_PROP_INDEX(ped, ID, val, 0, true, false)
            local textureVariations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(ped, ID, val)
            Option.setLimits(textures, 0, textureVariations - 1, 1)
            Option.setValue(textures, 0, true)
        end):setConfigIgnore()
        textures = submenu:add_num_option("Texture", "BS_Self_Wardrobe_" .. name .."_Texture", 0, 0, 1, function (val)
            if PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(ped, ID, variations:getValue()) == 0 then return end
            local ped = PLAYER.PLAYER_PED_ID()
            PED.SET_PED_PROP_INDEX(ped, ID, variations:getValue(), val, true, false)
        end):setConfigIgnore()
        submenu:add_click_option("Remove component", "BS_Self_Wardrobe_" .. name .."_Remove", function ()
            PED.CLEAR_PED_PROP(PLAYER.PLAYER_PED_ID(), ID, false)
        end):setConfigIgnore()
        wardrobe:add_sub_option(name, "BS_Self_Wardrobe_" .. name, submenu, function ()
            local ped = PLAYER.PLAYER_PED_ID()
            local drawableVariations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(ped, ID)
            Option.setLimits(variations, 0, drawableVariations - 1, 1)
            Option.setValue(variations, PED.GET_PED_DRAWABLE_VARIATION(ped, ID), true)
            local textureVariations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(ped, ID, 0)
            Option.setLimits(textures, 0, textureVariations - 1, 1)
            Option.setValue(textures, PED.GET_PED_TEXTURE_VARIATION(ped, ID), true)
        end)
    end
    wardrobe:add_separator("Components", "BS_Self_Wardrobe_Components")
    local components = {
        ["Head"] = 0,
        ["Beard"] = 1,
        ["Hair"] = 2,
        ["Torso"] = 3,
        ["Legs"] = 4,
        ["Hands"] = 5,
        ["Foot"] = 6,
        ["Misc"] = 7,
        ["Accessories"] = 8,
        ["Bags"] = 9,
        ["Decals & masks"] = 10,
        ["Auxiliary torso parts"] = 11,
    }
    for name, ID in pairs(components) do
        local ped = PLAYER.PLAYER_PED_ID()
        local submenu = Submenu.add_static_submenu(name, "BS_Self_Wardrobe_" .. name .."_Submenu")
        local drawableVariations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(ped, ID)
        local textures
        local variations = submenu:add_num_option("Variation", "BS_Self_Wardrobe_" .. name .."_Variation", 0, drawableVariations - 1, 1, function (val)
            local ped = PLAYER.PLAYER_PED_ID()
            PED.SET_PED_COMPONENT_VARIATION(ped, ID, val, 0, 0)
            local textureVariations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(ped, ID, val)
            Option.setLimits(textures, 0, textureVariations - 1, 1)
            Option.setValue(textures, 0, true)
        end):setConfigIgnore()
        textures = submenu:add_num_option("Texture", "BS_Self_Wardrobe_" .. name .."_Texture", 0, 0, 1, function (val)
            if PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(ped, ID, variations:getValue()) == 0 then return end
            local ped = PLAYER.PLAYER_PED_ID()
            PED.SET_PED_COMPONENT_VARIATION(ped, ID, variations:getValue(), val, 0)
        end):setConfigIgnore()
        wardrobe:add_sub_option(name, "BS_Self_Wardrobe_" .. name, submenu, function ()
            local ped = PLAYER.PLAYER_PED_ID()
            local drawableVariations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(ped, ID)
            Option.setLimits(variations, 0, drawableVariations - 1, 1)
            Option.setValue(variations, PED.GET_PED_DRAWABLE_VARIATION(ped, ID), true)
            local textureVariations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(ped, ID, 0)
            Option.setLimits(textures, 0, textureVariations - 1, 1)
            Option.setValue(textures, PED.GET_PED_TEXTURE_VARIATION(ped, ID), true)
        end)
    end
    Self:add_sub_option("Wardrobe", "BS_Self_Wardrobe_SubOption", wardrobe, function ()
        notify.default("Wardrobe", "You can edit your outfits here.\nAlso you can save your outfit in 'Presets' submenu.")
    end)
end

local wanted = Submenu.add_static_submenu("Wanted options", "BS_Self_Wanted_Submenu") do
    local lvl = wanted:add_num_option("Wanted level", "BS_Self_Wanted_Level", 0, 5, 1, function (val)
        PLAYER.SET_PLAYER_WANTED_LEVEL(PLAYER.PLAYER_ID(), val, false)
        PLAYER.SET_PLAYER_WANTED_LEVEL_NOW(PLAYER.PLAYER_ID(), false)
    end)
    wanted:add_looped_option("Lock wanted level", "BS_Self_Wanted_LockLevel", 0.0, function ()
        PLAYER.SET_PLAYER_WANTED_LEVEL(PLAYER.PLAYER_ID(), lvl:getValue(), false)
        PLAYER.SET_PLAYER_WANTED_LEVEL_NOW(PLAYER.PLAYER_ID(), false)
    end)
    wanted:add_looped_option("Disable wanted music", "BS_Self_Wanted_NoMusic", 0.0, function ()
        AUDIO.SET_AUDIO_FLAG("WantedMusicDisabled", true)
    end)
    wanted:add_looped_option("Disable police blips", "BS_Self_Wanted_NoPoliceBlips", 0.0, function ()
        PLAYER.SET_POLICE_RADAR_BLIPS(false)
    end, function ()
        PLAYER.SET_POLICE_RADAR_BLIPS(true)
    end)
    wanted:add_looped_option("Police ignore", "BS_Self_Wanted_PoliceIgnore", 0.0, function ()
        PLAYER.SET_POLICE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), true)
    end, function ()
        PLAYER.SET_POLICE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), false)
    end):setHint("You will be ignored by the police.")
    wanted:add_looped_option("Suppress witnesses", "BS_Self_Wanted_SupressWitnesses", 0.0, function ()
        PLAYER._0x36F1B38855F2A8DF(PLAYER.PLAYER_ID())
    end):setHint("No one will call police to report you.")
    Self:add_sub_option("Wanted options", "BS_Self_Wanted_SubOption", wanted)
end

Self:add_separator("Movement", "BS_Self_Movement")

Self:add_looped_option("Clumsiness", "BS_Self_Movement_Clumsiness", 0.0, function ()
    PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), not PED.IS_PED_RUNNING_RAGDOLL_TASK(PLAYER.PLAYER_PED_ID()))
end)

Self:add_looped_option("No ragdoll", "BS_Self_Movement_NoRagdoll", 0.0, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    PED.SET_PED_CAN_RAGDOLL(ped, false)
    PED.SET_PED_CAN_RAGDOLL_FROM_PLAYER_IMPACT(ped, false)
    PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, false)
end, function ()
    local ped = PLAYER.PLAYER_PED_ID()
    PED.SET_PED_CAN_RAGDOLL(ped, true)
    PED.SET_PED_CAN_RAGDOLL_FROM_PLAYER_IMPACT(ped, true)
    PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, true)
end)

Self:add_choose_option("Running speed", "BS_Self_Movement_RunSpeed", true, {"Default", "Medium", "Fast"}, function (_, option)
    if task.exists("BS_Self_Movement_RunSpeed") then return end
    task.createTask("BS_Self_Movement_RunSpeed", 0.0, nil, function ()
        local value = 1.0
        if option:getValue() == 2 then
            value = 1.25
        elseif option:getValue() == 3 then
            value = 1.49
        end
        PLAYER.SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), value)
    end)
end):setValue(1.0, true)

Self:add_choose_option("Swimming speed", "BS_Self_Movement_SwimSpeed",true, {"Default", "Medium", "Fast"}, function (_, option)
    if task.exists("BS_Self_Movement_SwimSpeed") then return end
    task.createTask("BS_Self_Movement_SwimSpeed", 0.0, nil, function ()
        local value = 1.0
        if option:getValue() == 2 then
            value = 1.25
        elseif option:getValue() == 3 then
            value = 1.49
        end
        PLAYER.SET_SWIM_MULTIPLIER_FOR_PLAYER(PLAYER.PLAYER_ID(), value)
    end)
end):setValue(1.0, true)

Self:add_looped_option("Swimming mode", "BS_Self_Movement_SwimmingMode", 0.0, function (state)
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 65, state)
end)

Self:add_looped_option("Shrink", "BS_Self_Movement_ShrinkMode", 0.0, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, true)
end, function ()
    PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, false)
end)

Self:add_looped_option("Always have a parachute", "BS_Self_Movement_AlwHaveParachute", 0.0, function (state)
    local ped = PLAYER.PLAYER_PED_ID()
    local hash = string.joaat("GADGET_PARACHUTE")
    if not WEAPON.HAS_PED_GOT_WEAPON(ped, hash, false) then
        WEAPON.GIVE_WEAPON_TO_PED(ped, hash, 5, false, false)
        notify.success("Self", "You've got a new parachute. Stay safe!")
    end
end)

Self:add_looped_option("Infinite stamina", "BS_Self_Movement_InfiniteStamina", 0.0, function ()
    PLAYER.RESET_PLAYER_STAMINA(PLAYER.PLAYER_ID())
end)

Self:add_separator("Gameplay", "BS_Self_Gameplay")

Self:add_looped_option("Total ignorе", "BS_Self_TotalIgnore", 0.0, function ()
    local player = PLAYER.PLAYER_ID()
    PLAYER.SET_POLICE_IGNORE_PLAYER(player, true)
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(player, true)
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(player, false)
    PLAYER.SET_IGNORE_LOW_PRIORITY_SHOCKING_EVENTS(player, true)
end, function ()
    local player = PLAYER.PLAYER_ID()
    PLAYER.SET_POLICE_IGNORE_PLAYER(player, false)
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(player, false)
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(player, true)
    PLAYER.SET_IGNORE_LOW_PRIORITY_SHOCKING_EVENTS(player, false)
end):setHint("Most of peds nearby will ignore you.")

Self:add_click_option("Sky dive", "BS_Self_SkyDive", function ()
    local ped = PLAYER.PLAYER_PED_ID()
    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 0.0, 150.0)
    utils.teleport(coords)
    TASK.TASK_SKY_DIVE(ped, true)
end)

Self:add_looped_option("Always clean", "BS_Self_AlwClean", 0.0, function ()
    local ped = player.id()
    PED.CLEAR_PED_WETNESS(ped)
    PED.CLEAR_PED_BLOOD_DAMAGE(ped)
end)

--END