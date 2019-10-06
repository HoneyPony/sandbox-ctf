extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0, 0)

var gravity = Vector2(0, 120)

var player

var attacking = false
var attack_timer = 0

var on_ground = false

var jump_timer = 0

export var acceleration = 60

export var max_speed = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/root/physics_map").add_entity(self)
	
	player = get_node("/root/root/player")
	$animation_player.play("walk")
	
	pass # Replace with function body.

var knockback = 0
var knockback_v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if knockback > 0:
		move_and_collide(knockback_v * delta)
		knockback -= delta
		knockback_v -= (150 / 0.5) * delta * knockback_v.normalized()
		return
	
	var to_player = player.global_position - global_position
	
	if to_player.length() < 9 and not attacking:
		attack_timer = 0.7
		attacking = true
		velocity.x = 0
		$animation_player.play("attack")
	
	if not attacking:
		var harr = sign(to_player.x)
		
		if on_ground:
			velocity.x += harr * delta * acceleration
		else:
			velocity.x += harr * delta * acceleration / 2.0
		velocity.x = clamp(velocity.x, -30, 30)
	
	velocity += gravity * delta
	velocity.y = min(velocity.y, 240)
	
	velocity = move_and_slide(velocity)
	
	on_ground = false
	
	for i in range(0, get_slide_count()):
		var coll = get_slide_collision(i)
		if coll.normal.dot(Vector2.UP) > cos(PI / 4):
			on_ground = true
			
	if !attacking:
		if abs(velocity.x) < 10:
			if on_ground and jump_timer <= 0:
				velocity.y = -80
				on_ground = false
				jump_timer = 0.2
				
	if on_ground and jump_timer >= 0:
		jump_timer -= delta
		
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attacking = false
		
	if velocity.x != 0:
		$flipper.scale.x = sign(velocity.x)
		
func you_died():
	pass
	
func you_were_hit():
	var heading = (player.global_position - global_position).normalized()
	knockback = 0.5
	knockback_v = heading * -150
	velocity = Vector2(0, 0)