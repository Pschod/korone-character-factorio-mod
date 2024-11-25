local IMG_PATH = korone.modRoot .. "/graphics/"

local IMG_PATH_LVL1 = korone.modRoot .. "/graphics/lvl1/"
local IMG_PATH_LVL2 = korone.modRoot .. "/graphics/lvl2/"
local IMG_PATH_LVL3 = korone.modRoot .. "/graphics/lvl3/"

local util = require("util")
local my_character = {}

local anim_speed = 0.4;
local sprite_scale = 0.4;
local sprite_scale_shadow = 0.25;
local img_width = 180;
local img_height = 225;
local img_width_shadow = 400;
local img_height_shadow = 180;
local img_shift = util.by_pixel(0, -15.5)
local img_shift_shadow = util.by_pixel(28, 3)

function getAnimationWithHr(s)
    local hr = util.table.deepcopy(s)
    s.hr_version = hr
    return s
end

function getSeqPics(prefix, max)
    local s = {}
    for i = 1, max do
        table.insert(s, prefix .. i .. ".png")
    end
    return s
end

function getSeqPicsRange(prefix, min, max)
    local s = {}
    for i = min, max do
        table.insert(s, prefix .. i .. ".png")
    end
    return s
end


local function getHr(s)
    return getAnimationWithHr(s)
end


local function getDead(IMG_PATH)
    local s = {
        width = img_width,
        height = img_height,
        shift = img_shift,
        frame_count = 2,
        scale = 1,
        stripes = {
            {
                filename = IMG_PATH .. "dead_1.png",
                width_in_frames = 1,
                height_in_frames = 1,
            },
            {
                filename = IMG_PATH .. "dead_2.png",
                width_in_frames = 1,
                height_in_frames = 1,
            }, }
    }
    return getHr(s)
end

local function get_mapping(x)
    return (not data.is_demo) and x or nil
end

-- Load up an animation set from image path.
local function create_animation(path)
    return {
		idle = {
			filename = path .. "idle.png",
			width = img_width,
			height = img_height,
			shift = img_shift,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale,
			usage = "player",
		},
		idle_shadow = {
			filename = path .. "idle_shadow.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
		idle_with_gun = {
			filename = path .. "idle_gun.png",
			width = img_width,
			height = img_height,
			shift = img_shift,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale,
			usage = "player",
		},
		idle_with_gun_shadow = {
			filename = path .. "idle_gun_shadow.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
		mining_with_tool = {
			filename = path .. "mining_tool.png",
			width = img_width,
			height = img_height,
			shift = img_shift,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale,
			usage = "player",
		},
		mining_with_tool_shadow = {
			filename = path .. "mining_tool_shadow.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
		running = {
			filename = path .. "running.png",
			width = img_width,
			height = img_height,
			shift = img_shift,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale,
			usage = "player",
		},
		running_shadow = {
			filename = path .. "running_shadow.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 8,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
		running_with_gun = {
			filename = path .. "running_gun.png",
			width = img_width,
			height = img_height,
			shift = img_shift,
			frame_count = 20,
			direction_count = 18,
			animation_speed = anim_speed,
			scale = sprite_scale,
			usage = "player",
		},
		running_with_gun_shadow = {
			filename = path .. "running_gun_shadow.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 18,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
		running_with_gun_shadow_flipped = {
			filename = path .. "running_gun_shadow_flipped.png",
			width = img_width_shadow,
			height = img_height_shadow,
			shift = img_shift_shadow,
			frame_count = 20,
			direction_count = 18,
			animation_speed = anim_speed,
			scale = sprite_scale_shadow,
			draw_as_shadow = true,
			usage = "player",
		},
    }
end

my_character.create = function(imgPath, name)

    -- Armorless
    local character_animation = create_animation(IMG_PATH_LVL1);
    -- Light and heavy armor
    local character_armored_animation = create_animation(IMG_PATH_LVL2);
    character_armored_animation.armors = {"light-armor", "heavy-armor"}
    -- Modular armor and above
    local character_power_armor_animation = create_animation(IMG_PATH_LVL3);
    character_power_armor_animation.armors = {"modular-armor", "power-armor", "power-armor-mk2"}


    local animations_live = {
        character_animation,
        character_armored_animation,
        character_power_armor_animation,
    }

    local animations_dead = {
        {
            layers = {
                getDead(imgPath)
            }
        },
        {
            layers = {
                getDead(imgPath)
            }
        },
        {
            layers = {
                getDead(imgPath)
            }
        }
    }

    ------------------------------------------------------------------------------------
    --                                Character corpse                                --
    ------------------------------------------------------------------------------------
    -- We only store properties with values different from the defaults
    -- Copy the corpse
    --~ local corpse = table.deepcopy(data.raw["character-corpse"]["character-corpse"])
    local corpse = {}
    corpse.name = name .. "-corpse"
    corpse.localised_name = { "entity-name." .. corpse.name }
    corpse.localised_description = { "entity-description." .. corpse.name }
    corpse.icon = imgPath .. "corpse.png"
    corpse.icon_size = 480
    corpse.pictures = animations_dead

    corpse.armor_picture_mapping = {
        ["heavy-armor"] = 2,
        ["light-armor"] = get_mapping(2),
        ["modular-armor"] = get_mapping(3),
        ["power-armor"] = get_mapping(3),
        ["power-armor-mk2"] = get_mapping(3)
    }
    ------------------------------------------------------------------------------------
    --                                    Character                                   --
    ------------------------------------------------------------------------------------
    -- 我们只存储与默认值不同的属性
    -- We only store properties with values different from the defaults
    local character = {}
    character.name = name
    character.localised_name = { "entity-name." .. character.name }
    character.localised_description = { "entity-name." .. character.name }
    character.icon = imgPath .. "icon.png"
    character.icon_size = 480

    character.animations = animations_live
    character.character_corpse = corpse.name

    character.tool_attack_result = {
        type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                type = "damage",
                damage = { amount = 8, type = "physical" }
            }
        }
    }
    character.footstep_particle_triggers = {
        {
            tiles = { "water-shallow" },
            type = "create-particle",
            repeat_count = 5,
            particle_name = "shallow-water-droplet-particle",
            initial_height = 0.2,
            speed_from_center = 0.01,
            speed_from_center_deviation = 0.05,
            initial_vertical_speed = 0.02,
            initial_vertical_speed_deviation = 0.05,
            offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } }
        },
        {
            tiles = { "water-mud" },
            type = "create-particle",
            repeat_count = 5,
            particle_name = "shallow-water-droplet-particle",
            initial_height = 0.2,
            speed_from_center = 0.01,
            speed_from_center_deviation = 0.05,
            initial_vertical_speed = 0.02,
            initial_vertical_speed_deviation = 0.05,
            offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } }
        }
    }
    character.water_reflection = {
        pictures = {
            filename = IMG_PATH .. "character-reflection.png",
            priority = "extra-high",
            -- flags = { "linear-magnification", "not-compressed" },
            -- default value: flags = { "terrain-effect-map" },
            width = 13,
            height = 19,
            shift = util.by_pixel(0, 67 * 0.5),
            scale = 5,
            variation_count = 1
        },
        rotate = false,
        orientation_to_variation = false
    }

    return {
        character = character,
        corpse = corpse
    }

end

return my_character
