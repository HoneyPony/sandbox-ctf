extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var to_copy: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	to_copy = get_node("/root/root/camera")
	pass # Replace with function body.

func _process(delta):
	position = to_copy.position
