extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var slot

var player

var Block = preload("res://block.gd")

var idle = preload("res://sprite/inventory_test.png")
var active = preload("res://sprite/inventory_active.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	slot = int(get_name())
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var item = player.inventory.items[slot]
	var id = item.id
	
	if id == -1:
		$frame/icon.hide()
		$frame/count.hide()
	else:
		$frame/icon.show()
		$frame/icon.set_texture(Block.get_icon(id))
		if item.count == 1:
			$frame/count.hide()
		else:
			$frame/count.show()
			$frame/count.set_text(String(item.count))
			
	if player.inventory.active_hotbar == slot:
		$frame.texture = active
	else:
		$frame.texture = idle
		
