extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var light

func tile_destroy(tilemap, x, y):
	print(light)
	light.get_parent().remove_child(light)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	light = get_node("light")
	remove_child(light)
	get_node("/root/root/light_viewport").add_child(light)
	light.set_owner(get_node("/root/root/light_viewport"))
	
	
	
	
	print(light)
	
	$torch/animation.play("fire")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
