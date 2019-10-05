extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
export var required_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = player.inventory_open == required_state
