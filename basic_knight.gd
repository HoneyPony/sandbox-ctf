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
	
	position = player.position
	
	pass # Replace with function body.

var knockback = 0
var knockback_v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_collision_layer_bit(14, player.position.y < position.y + 8)
	set_collision_mask_bit(14, player.position.y < position.y + 8)
	
	if knockback > 0:
		move_and_collide(knockback_v * delta)
		knockback -= delta
		knockback_v -= (150 / 0.5) * delta * knockback_v.normalized()
		return
	
	var to_player = player.global_position - global_position
	
	if abs(position.x - player.position.x) < 12 and abs(position.y - player.position.y) < 12 and not attacking:
		
		attacking = true
		velocity.x = 0
		$animation_player.play("attack")
		attack_timer = $animation_player.get_animation("attack").length
		$flipper.scale.x = sign(player.position.x - position.x)
	
	if not attacking:
		var harr = sign(to_player.x)
		
		if on_ground:
			velocity.x += harr * delta * acceleration
		else:
			velocity.x += harr * delta * acceleration / 2.0
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
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
				velocity.y = -100
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