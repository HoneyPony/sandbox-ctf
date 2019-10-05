extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Player speed = 2 pixels / 0.66 seconds for walkcycle

var walk_anim_speed = (2 / 0.66)

export var player_speed = 15
export var player_horizontal_acceleration = 1

var horizontal_v = 0
var last_horizontal_direction = 1

var anim_player

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player = get_node("animation_player")
	pass # Replace with function body.

func _process(delta):
	pass
	
func _physics_process(delta):
	var acc_h = -sign(horizontal_v)
	if Input.is_action_pressed("player_right"):
		acc_h = 1
	elif Input.is_action_pressed("player_left"):
		acc_h = -1
		
	var max_h = player_speed * walk_anim_speed
		
	horizontal_v += acc_h * delta * player_horizontal_acceleration
	horizontal_v = clamp(horizontal_v, -max_h, max_h)
	
	if abs(horizontal_v) < 0.2:
		if last_horizontal_direction > 0:
			anim_player.play("idle")
		else:
			anim_player.play("idle_left")
		horizontal_v = 0
	else:
		if horizontal_v > 0:
			anim_player.play("walk")
		else:
			anim_player.play("walk_left")
		last_horizontal_direction = horizontal_v
	
	position.x += horizontal_v * delta
	
	
	