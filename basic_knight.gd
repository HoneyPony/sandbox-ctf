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

export var may_have_flag = false

export var acceleration = 60

export var max_speed = 30

var Block = preload("res://block.gd")
var ItemPickup = preload("res://item_pickup.tscn")

func spawn_pickup(id):
	var x = round(position.x / 4)
	var y = round(position.y / 4)
	var pickup = ItemPickup.instance()
	get_node("/root/root").call_deferred("add_child", pickup)
	pickup.position = Vector2(x, y) * 4 + Vector2(2, 2)
	pickup.set_id(id)
	
func rand(a, b):
	return round(rand_range(a, b))
	
func drops():
	if may_have_flag:
		var drop_type = rand(0, 9)
		if drop_type == 7:
			spawn_pickup(Block.RED_FLAG)
		if drop_type < 4:
			for i in range(5, 9):
				spawn_pickup(Block.JAVELIN)
	else:
		var drop_type = rand(0, 3)
		if drop_type == 0:
			for i in range(1, 3):
				spawn_pickup(Block.ENERGY_PART)
		if drop_type == 1:
			for i in range(5, 9):
				spawn_pickup(Block.JAVELIN)
		if drop_type == 2:
			for i in range(0, 4):
				spawn_pickup(Block.WOOD)
			for i in range(0, 2):
				spawn_pickup(Block.COAL)

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
	if (position - player.position).length_squared() > 200 * 4 * 200 * 4:
		get_parent().remove_child(self)
		return
	
	#set_collision_layer_bit(14, player.position.y < position.y + 8)
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
	drops()
	
func you_were_hit():
	var heading = (player.global_position - global_position).normalized()
	knockback = 0.5
	knockback_v = heading * -150
	velocity = Vector2(0, 0)
