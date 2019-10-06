extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

var player_velocity = Vector2(0, 0)
var correction_velocity = Vector2(0, 0)
var hop_velocity = Vector2(0, 0)

var velocity = Vector2(0, 0)

var hop_length = 0.3
var hop_size = 20

export var max_speed = 45
export var acceleration = 200

var knockback = 0
var knockback_v

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/root/physics_map").add_entity(self)
	
	player = get_node("/root/root/player")
	$AnimationPlayer.play("fly")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if knockback > 0:
		move_and_collide(knockback_v * delta)
		knockback -= delta
		knockback_v -= (150 / 0.5) * delta * knockback_v.normalized()
		return
	
	hop_velocity.y += (hop_size / hop_length) * delta
	
	var heading = (player.global_position - global_position).normalized()
	player_velocity += acceleration * heading * delta
	
	if correction_velocity.length() < 400 * delta:
		correction_velocity = Vector2(0, 0)
	else:
		correction_velocity -= correction_velocity.normalized() * 400 * delta
		if correction_velocity.length() < 3:
			correction_velocity = Vector2(0, 0)
	
	velocity = player_velocity + correction_velocity + hop_velocity
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	velocity = move_and_slide(velocity)
	player_velocity = velocity
	
	if velocity.x > 0:
		$flipper.scale.x = -1
	else:
		$flipper.scale.x = 1
	
	for i in range(0, min(get_slide_count(), 1.0)):
		var c = get_slide_collision(i)
		correction_velocity += c.normal
		
	if get_slide_count() > 0:
		if correction_velocity.y <= 0:
			correction_velocity.y -= 1
		else:
			correction_velocity.y += 1
		correction_velocity = (correction_velocity).normalized() * 200

func hop():
	var heading = (player.global_position - global_position).normalized()
	var correction = 0
	if heading.y < -0.5:
		correction = 0.1
	if heading.y > 0.5:
		correction = -0.1
	hop_velocity.y = -hop_size * (0.5 + correction)
	
func you_died():
	pass
	
func you_were_hit():
	var heading = (player.global_position - global_position).normalized()
	knockback = 0.5
	knockback_v = heading * -150
	velocity = Vector2(0, 0)