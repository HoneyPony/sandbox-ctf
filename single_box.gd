extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = global.tiles
	pass # Replace with function body.

func update_box():
	var x = round(global_position.x / 4)
	var y = round(global_position.y / 4)
	var a = 0.5
	$shape.disabled = tilemap.get_cell(x, y) == -1
	if not $shape.disabled:
		a = 1
	$Sprite.modulate.a = a
	
	
		
