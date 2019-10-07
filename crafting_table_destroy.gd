extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CRAFTING = 0
const FURNACE = 1
const CHEST = 2

export var mode = 0

var light

var Block = preload("res://block.gd")

func tile_destroy(tilemap, x, y):
	if mode == CRAFTING:
		tilemap.set_cell(x, y, -1)
		tilemap.set_cell(x + 1, y, -1)
		return Block.CRAFT_TABLE
	if mode == FURNACE:
		tilemap.set_cell(x, y, -1)
		tilemap.set_cell(x + 1, y, -1)
		tilemap.set_cell(x, y - 1, -1)
		tilemap.set_cell(x + 1, y - 1, -1)
		
		if light == null:
			return Block.FURNACE
	
		light.get_parent().remove_child(light)
		light = null
		
		return Block.FURNACE
	if mode == CHEST:
		tilemap.set_cell(x, y, -1)
		tilemap.set_cell(x + 1, y, -1)
		tilemap.set_cell(x, y - 1, -1)
		tilemap.set_cell(x + 1, y - 1, -1)
		return Block.CHEST

# Called when the node enters the scene tree for the first time.
func _ready():
	if mode == FURNACE:
		light = load("res://torch_light.tscn").instance()
		light.position = position
		get_node("/root/root/light_viewport").add_child(light)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
