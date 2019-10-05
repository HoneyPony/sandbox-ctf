extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id_to_tex = {
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png")
}

var id = 0
var player

var accepted = false

var anim = 0

var last_position
var interpolate_position

var tilemap
var physics_map

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	tilemap = get_node("/root/root/tiles")
	physics_map = get_node("/root/root/physics_map")
	last_position = position
	pass # Replace with function body.
	
func set_id(x):
	id = x
	$item.texture = id_to_tex.get(id)

func picked_up(unused):
	if accepted:
		return
	
	if player.inventory.accept(id):
		accepted = true
		interpolate_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if accepted:
		position = interpolate_position * (1.0 - anim) + player.position * anim
		modulate.a = 1.0 - anim
		anim += dt * 2
		if anim > 1:
			get_parent().remove_child(self)
	var delta = position - last_position
	if delta.length_squared() < 0.0001:
		position.x = round(position.x)
		position.y = round(position.y)
	last_position = position
	
var velocity = 0
var gravity = 120
	
func _physics_process(dt):
	var ax = position.x
	
	velocity += dt * gravity
	var max_speed = 4
	var speed = min(velocity * dt, 4)
	
	if abs(speed) > 0.1:
		var x = round(position.x / 4)
		var y = round(position.y / 4)
		if tilemap.get_cell(x, y + 1) != -1:
			physics_map.set_cell(x, y + 1, 0)
	
	move_and_collide(Vector2(0, speed))
	position.x = ax
