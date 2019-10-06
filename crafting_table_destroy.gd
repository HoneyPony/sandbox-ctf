extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CRAFTING = 0
const FURNACE = 1

export var mode = 0

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
		return Block.FURNACE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
