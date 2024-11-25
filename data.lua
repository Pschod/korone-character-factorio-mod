korone = require("__CharacterModHelper__.common")("korone-character")

korone.IMG_PATH = korone.modRoot.."/graphics/"

local character_creator = require("character_creator")

korone.new_characters = {}

local character_name = "Korone_character_skin"

korone.new_characters[character_name] = character_creator.create(korone.IMG_PATH, character_name)

CharModHelper.create_prototypes(korone.new_characters[character_name])
CharModHelper.check_my_prototypes(korone.new_characters[character_name])