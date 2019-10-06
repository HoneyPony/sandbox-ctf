extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Player speed = 2 pixels / 0.66 seconds for walkcycle

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

var Inventory

var inventory

var camera1
var camera2

var crafting_tables = 0
var at_crafting_table = false

var craft_sentinel

func notify_crafting():
	var last = at_crafting_table
	at_crafting_table = crafting_tables > 0
	if at_crafting_table != last:
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
	Inventory = load("res://inventory.gd")
	inventory = Inventory.new(self)
	
	anim_player = get_node("animation_player")
	
	camera1 = get_node("/root/root/camera")
	camera2 = get_node("/root/root/block_break_viewport/camera")
	
	craft_sentinel = get_node("/root/root/ui/crafting/sentinel")
	pass # Replace with function body.

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var ext = ""
		if last_horizontal_direction < 0:
			ext = "_left"
		$item_swing/animation_player.play("swing" + ext)
	if Input.is_action_just_pressed("inventory_open"):
		inventory_open = !inventory_open
		
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
	
func _physics_process(delta):
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
		
	var max_h = player_speed
		
	horizontal_v += acc_h * delta * player_horizontal_acceleration
	horizontal_v = clamp(horizontal_v, -max_h, max_h)
	
	var attempted_horizontal_v = horizontal_v
	
	vertical_v += (gravity - current_jump_impulse) * delta
	current_jump_impulse_delta += jump_impulse_delta_delta() * delta
	current_jump_impulse -= current_jump_impulse_delta * delta
	current_jump_impulse = max(current_jump_impulse, 0)
	
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
			next_anim = "idle"
			
	if last_horizontal_direction < 0:
		next_anim += "_left"
		
	if next_anim != "":
		anim_player.play(next_anim)
		
	camera1.position = position
	camera2.position = position
	
	#print(position.y)
	