extends Control

export var required_state = false
export var required_chest = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = global.player.inventory_open == required_state
	if required_chest:
		visible = visible and global.player.chest_open
