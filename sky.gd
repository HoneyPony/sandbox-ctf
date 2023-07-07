extends Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = global.player.position
	position.y = min(position.y, -256)
