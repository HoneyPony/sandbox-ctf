extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var number

var full = preload("res://sprite/player_heart.png")
var half = preload("res://sprite/player_half_heart.png")
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	number = int(get_name()) + 1
	player = global.player
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.health < number * 2:
		if player.health < number * 2 - 1:
			texture = null
		else:
			texture = half
	else:
		texture = full
