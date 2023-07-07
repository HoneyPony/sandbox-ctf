extends StaticBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	var delta = position - global.player.position
	
	if delta.length() > 24:
		return
		
	for item in global.player.inventory.items:
		if item.id == -28:
			get_tree().change_scene("res://win.tscn")
