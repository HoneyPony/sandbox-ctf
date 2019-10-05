extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var item_map = {
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png")
}

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var id = player.inventory.active_item().id
	if id in item_map:
		texture = item_map.get(id)
		show()
	else:
		hide()
