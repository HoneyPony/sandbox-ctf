extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var items: Array

var Inv = preload("res://inventory.gd")

var mouse_used = false
var can_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	
	for i in range(0, 18):
		items.append(Inv.Item.new())
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var m = get_local_mouse_position()
	can_open = m.x > -4 and m.y > -4 and m.x < 4 and m.y < 4
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if can_open and not mouse_used:
			player.set_chest(self)
			player.open_chest()
			
			mouse_used = true
	else:
		mouse_used = false
