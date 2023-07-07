extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = global.player
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var id = player.inventory.active_item().id
	if Block.is_block(id):
		texture = Block.get_texture(id)
		show()
	else:
		hide()
