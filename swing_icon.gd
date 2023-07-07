extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id

# Called when the node enters the scene tree for the first time.
func _ready():
	use_parent_material = true
	id = int(get_name())
	visible = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = (id == global.player.inventory.active_item().id)
