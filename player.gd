extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Player speed = 2 pixels / 0.66 seconds for walkcycle

onready var right_stair_top = $right_stair_top
onready var right_stair_bottom = $right_stair_bottom

export var player_speed = 40
export var player_horizontal_acceleration = 1

var horizontal_v = 0
var last_horizontal_direction = 1

var vertical_v = 0
export var gravity = 1

var current_jump_impulse = 0
var current_jump_impulse_delta = 0
export var initial_jump_impulse = 1500
export var initial_jump_impulse_delta = 1000
export var jump_impulse_delta_delta = 700
export var jump_cancel_delta_delta = 1800

var on_ground = false
var zero_collision_frames = 0

var anim_player
var equipped = false

var Inventory

var inventory

var camera1
var camera2
var camera3

var crafting_tables = 0
var at_crafting_table = false

var furnaces = 0
var at_furnace = false

var craft_sentinel

var health = 40

var current_chest = null
var chest_open = false

func should_up_stair_right():
	print("p/t: ", right_stair_top.overlaps_body(global.physics_map), " b: ", right_stair_bottom.overlaps_body(global.physics_map))
	if right_stair_top.get_overlapping_bodies().empty():
		if not right_stair_bottom.get_overlapping_bodies().empty():
			print("TRUE")
			return true
	return false

func set_chest(node):
	current_chest = node
		
func open_chest():
	if inventory_open:
		if chest_open:
			inventory_open = false
			chest_open = false
		else:
			chest_open = true
	else:
		inventory_open = true
		chest_open = true

func notify_crafting():
	var last = at_crafting_table
	at_crafting_table = crafting_tables > 0
	if at_crafting_table != last:
		craft_sentinel.create_recipe_ui()
		
	last = at_furnace
	at_furnace = furnaces > 0
	if at_furnace != last:
		craft_sentinel.create_recipe_ui()

var inventory_open = false
var Block = preload("res://block.gd")

func current_dirt():
	return Block.dirt_strength(inventory.active_item().id)
	
func current_rock():
	return Block.rock_strength(inventory.active_item().id)

func current_wood():
	return Block.wood_strength(inventory.active_item().id)

# Called when the node enters the scene tree for the first time.
func _ready():
	global.player = self
	
	Inventory = load("res://inventory.gd")
	inventory = Inventory.new(self)
	
	anim_player = get_node("animation_player")
	
	var root = get_parent()
	
	camera1 = root.get_node("camera")
	camera2 = root.get_node("block_break_viewport/camera")
	camera3 = root.get_node("light_viewport/camera")
	
	craft_sentinel = root.get_node("ui/crafting/sentinel")
	
	pass # Replace with function body
	
func spawn():
	if inventory != null:
		for item in inventory.items:
			if item.id == Block.RED_FLAG:
				return
	position = global.spawn_point.position + Vector2(4, -5)
	horizontal_v = 0
	vertical_v = 0
	last_horizontal_direction = 1
	on_ground = true

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var ext = ""
		if last_horizontal_direction < 0:
			ext = "_left"
		$item_swing/animation_player.play("swing" + ext)
	if Input.is_action_just_pressed("inventory_open"):
		inventory_open = !inventory_open
		current_chest = null
		chest_open = false
		
	if not equipped:
		for item in inventory.items:
			if Block.damage(item.id) > 1:
				equipped = true
		
func _input(event):
	# Don't handle while inventory open
	if inventory_open:
		return
	
	if event.is_action_pressed("inventory_next"):
		inventory.active_hotbar += 1
	if event.is_action_pressed("inventory_previous"):
		inventory.active_hotbar -= 1
	if inventory.active_hotbar < 0:
		inventory.active_hotbar = 9
	if inventory.active_hotbar > 9:
		inventory.active_hotbar = 0
		
	
		
	
#func _unhandled_input(event):
#	if inventory_open:
#		return
#
#	if event is InputEventMouseButton:
#		if event.is_pressed():
#			if event.button_index == BUTTON_WHEEL_UP:
#				inventory.active_hotbar += 1
#			if event.button_index == BUTTON_WHEEL_DOWN:
#				inventory.active_hotbar -= 1
#			if inventory.active_hotbar < 0:
#				inventory.active_hotbar = 9
#			if inventory.active_hotbar > 9:
#				inventory.active_hotbar = 0
	
func jump_impulse_delta_delta():
	if Input.is_action_pressed("player_jump"):
		return jump_impulse_delta_delta
	else:
		return jump_cancel_delta_delta
		
func handle_stairs():
	# heading right
	#print(horizontal_v)
	if horizontal_v > player_speed * 0.5:
		#print("Stiars!")
		if should_up_stair_right():
			print("STAIRS")
			move_and_collide(Vector2(0, -4))
			move_and_collide(Vector2(0.1, 0))
			# Necessary?
			#move_and_slide(Vector2(0.2, 0))
	
func _physics_process(delta):	
	#set_collision_layer_bit(14, !Input.is_action_pressed("player_down"))
	set_collision_mask_bit(14, !Input.is_action_pressed("player_down"))

	var acc_h = -sign(horizontal_v)
	if Input.is_action_pressed("player_right"):
		acc_h = 1
	elif Input.is_action_pressed("player_left"):
		acc_h = -1
		
	if on_ground:
		if Input.is_action_pressed("player_jump"):
			current_jump_impulse = initial_jump_impulse
			current_jump_impulse_delta = 0
			on_ground = false
			$jump.play()
		
	var max_h = player_speed
		
	horizontal_v += acc_h * delta * player_horizontal_acceleration
	horizontal_v = clamp(horizontal_v, -max_h, max_h)
	
	var attempted_horizontal_v = horizontal_v
	
	vertical_v += (gravity - current_jump_impulse) * delta
	current_jump_impulse_delta += jump_impulse_delta_delta() * delta
	current_jump_impulse -= current_jump_impulse_delta * delta
	current_jump_impulse = max(current_jump_impulse, 0)
	
	# Handle stairs before regular movement so that we will slide
	# onto the stairs with our horizontal velocity.
	#handle_stairs()
	
	var v = move_and_slide(Vector2(horizontal_v, vertical_v))
	horizontal_v = v.x
	vertical_v = v.y
	for i in get_slide_count():
		var coll = get_slide_collision(i)
		if coll.normal.dot(Vector2.UP) > cos(PI / 4):
			on_ground = true
			zero_collision_frames = 0
			
	if zero_collision_frames > 2:
		on_ground = false
	else:
		zero_collision_frames += 1
			
	if abs(horizontal_v) < player_horizontal_acceleration * delta * 0.9:
		horizontal_v = 0
	else:
		last_horizontal_direction = horizontal_v
			
	var next_anim = ""
	
	if on_ground:
		if abs(attempted_horizontal_v) < 0.5:
			next_anim = "idle"
		else:
			next_anim = "walk"
	else:
		if vertical_v < 0:
			next_anim = "jumping"
		else:
			next_anim = "falling"
			
	if last_horizontal_direction < 0:
		next_anim += "_left"
		
	if next_anim != "":
		anim_player.play(next_anim)
		
	camera1.position = position
	camera2.position = position
	camera3.position = position
	#print(position.y)
	

func hit(body):
	# todo get thing
	health -= 0
	if health < 0:
		var permadeath = global.permadeath
		if permadeath:
			get_tree().change_scene("res://lose.tscn")
		else:
			for item in inventory.items:
				if item.id == Block.RED_FLAG:
					item.id = -1
					item.count = 0
			health = 40
			spawn()
	$hit.play()
