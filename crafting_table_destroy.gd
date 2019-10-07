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

var is_first_destroy = true

func is_at(x, y):
	var px = int(position.x / 4)
	var py = int(position.y / 4)
	
	if mode == CRAFTING:
		return y == py and ((x == px) or (x == px + 1))
	if mode == FURNACE or mode == CHEST:
		var sy = (y == py) or (y == py - 1)
		var sx = (x == px) or (x == px + 1)
		return sx and sy
	return false

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
		
		if is_first_destroy:
			$sprite.spawn_pickups()
			is_first_destroy = false
		
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
