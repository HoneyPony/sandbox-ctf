const icon_map = {
	-3: preload("res://sprite/stickaxe_icon.png"),
	-2: preload("res://sprite/crafting_table_icon.png"),
	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png"),
	2: preload("res://sprite/rocks_icon.png"),
	3: preload("res://sprite/wood_icon.png")
}

const texture_map = {
	-2: preload("res://sprite/crafting_table.png"),
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png"),
	2: preload("res://sprite/rocks.png"),
	3: preload("res://sprite/wood.png")
}

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

static func item_strength(id):
	return 1