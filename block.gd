const icon_map = {
	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png")
}

const texture_map = {
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png")
}

static func get_icon(id):
	return icon_map.get(id)
	
static func get_texture(id):
	return texture_map.get(id)
	
static func is_block(id):
	return id >= 0
	
static func is_item(id):
	return id < -1
