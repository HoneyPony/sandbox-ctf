extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var light

func is_at(x, y):
	var px = int(position.x / 4)
	var py = int(position.y / 4)
	return x == px and y == py

func tile_destroy(tilemap, x, y):
	tilemap.set_cell(x, y, -1)
	
	# called multiple times
	if light == null:
		return -10

	light.get_parent().remove_child(light)
	light = null
	pass
	
	return -10

# Called when the node enters the scene tree for the first time.
func _ready():
	light = load("res://torch_light.tscn").instance()
	light.position = position
	global.light_viewport.add_child(light)
	
	$sprite/animation.play("fire")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
