const icon_map = {
	-6: preload("res://sprite/furnace_icon.png"),
	-5: preload("res://sprite/wood_shovel_icon.png"),
	-4: preload("res://sprite/wood_axe_icon.png"),
	-3: preload("res://sprite/stickaxe_icon.png"),
	-2: preload("res://sprite/crafting_table_icon.png"),
	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png"),
	2: preload("res://sprite/rocks_icon.png"),
	3: preload("res://sprite/wood_icon.png"),
	4: preload("res://sprite/coal_icon.png"),
	-7: preload("res://sprite/rock_pick_icon.png"),
	-8: preload("res://sprite/rock_axe_icon.png"),
	-9: preload("res://sprite/rock_shovel_icon.png"),
	5: preload("res://sprite/copper_ore.png"),
}

const texture_map = {
	-2: preload("res://sprite/crafting_table.png"),
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png"),
	2: preload("res://sprite/rocks.png"),
	3: preload("res://sprite/wood.png"),
	4: preload("res://sprite/coal.png"),
	5: preload("res://sprite/copper_ore.png")
}

const CAT_DIRT = 0
const CAT_ROCK = 1
const CAT_WOOD = 2

const GRASS = 0
const DIRT = 1
const ROCK = 2
const WOOD = 3
const COAL = 4
const COPPER_ORE = 5
const CRAFT_TABLE = -2
const WOOD_PICK = -3
const WOOD_AXE = -4
const WOOD_SHOVEL = -5
const FURNACE = -6
const ROCK_PICK = -7
const ROCK_AXE = -8
const ROCK_SHOVEL = -9

static func tiles(id):
	if id == -1:
		return 1
	if id == 0:
		return 64
	if id == 1:
		return 64
	if id == 2:
		return 64
	if id == 3:
		return 4
	if id == 4:
		return 16
	if id == 5:
		return 64

static func get_icon(id):
	return icon_map.get(id)
	
static func get_texture(id):
	return texture_map.get(id)
	
static func is_block(id):
	return id >= 0
	
static func is_placeable(id):
	return id >= 0
	
static func is_stackable(id):
	return id >= -1
	
static func is_item(id):
	return id < -1
	
static func category(id):
	if id == 0: return CAT_DIRT
	if id == 1: return CAT_DIRT
	if id == 2: return CAT_ROCK
	if id == 3: return CAT_WOOD

static func wood_strength(id):
	if id == ROCK_AXE:
		return 1.8
	if id == -4:
		# ok early axe
		return 1.5
	return 1
	
static func rock_strength(id):
	if id == ROCK_PICK:
		return 1.3
	if id == -3:
		# we used to use 5 here because 1/0.2 = 5. but these aren't multiplied so don't od that
		return 1.1
	# rocks are slow without a pick
	return 0.2
	
static func dirt_strength(id):
	if id == ROCK_SHOVEL:
		return 3.5
	if id == -5:
		# early shovel boost
		return 2.5
	
	return 1
	
# in case we want to make a really slow block
# use e.g. 0.5
# to make block faster do 2.0 or something
static func block_slowdown(id):
	return 1