extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	id = int(get_name())
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = (id == player.inventory.active_item().id)
