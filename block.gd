const icon_map = {
	-5: preload("res://sprite/wood_shovel_icon.png"),
	-4: preload("res://sprite/wood_axe_icon.png"),
	-3: preload("res://sprite/stickaxe_icon.png"),
	-2: preload("res://sprite/crafting_table_icon.png"),
	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png"),
	2: preload("res://sprite/rocks_icon.png"),
	3: preload("res://sprite/wood_icon.png"),
	4: preload("res://sprite/coal_icon.png")
}

const texture_map = {
	-2: preload("res://sprite/crafting_table.png"),
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png"),
	2: preload("res://sprite/rocks.png"),
	3: preload("res://sprite/wood.png"),
	4: preload("res://sprite/coal.png")
}

const CAT_DIRT = 0
const CAT_ROCK = 1
const CAT_WOOD = 2

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
	if id == -4:
		# ok early axe
		return 1.5
	return 1
	
static func rock_strength(id):
	if id == -3:
		# we used to use 5 here because 1/0.2 = 5. but these aren't multiplied so don't od that
		return 1.1
	# rocks are slow without a pick
	return 0.2
	
static func dirt_strength(id):
	if id == -5:
		# early shovel boost
		return 2.5
	if id == -3:
		# small boost for pick
		return 1.1
	return 1
	
# in case we want to make a really slow block
# use e.g. 0.5
# to make block faster do 2.0 or something
static func block_slowdown(id):
	return 1