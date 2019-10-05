extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id_to_tex = {
	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png")
}

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	pass # Replace with function body.

func goto(v):
	margin_left = v.x
	margin_top = v.y
	margin_right = v.x + 40
	margin_bottom = v.y + 40

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player.inventory_open:
		hide()
		return
	
	goto(get_global_mouse_position() - Vector2(8, 8))
	if player.inventory.floating_item.id != -1:
		texture = id_to_tex.get(player.inventory.floating_item.id)
		$count.text = String(player.inventory.floating_item.count)
		$count.visible = player.inventory.floating_item.count > 1
	
	visible = player.inventory.floating_item.id != -1
