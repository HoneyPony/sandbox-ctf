extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	player_sprite = get_parent().get_node("sprite")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_sprite.flip_h:
		scale.x = -1
	else:
		scale.x = 1
