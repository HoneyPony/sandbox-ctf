extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	var delta = position - player.position
	
	if delta.length() > 24:
		return
		
	for item in player.inventory.items:
		if item.id == -28:
			get_tree().change_scene("res://win.tscn")
