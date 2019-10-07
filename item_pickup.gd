extends KinematicBody2D

var id = 0
var player

var accepted = false

var anim = 0

var last_position
var interpolate_position

var tilemap
var physics_map

var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	tilemap = get_node("/root/root/tiles")
	physics_map = get_node("/root/root/physics_map")
	last_position = position
	pass # Replace with function body.
	
func set_id(x):
	id = x
	$item.texture = Block.get_texture(id)
	if Block.is_block(id):
		$item.region_rect = Rect2(0, 0, 4, 4)
		$item.region_enabled = true
		$frame.visible = true

func picked_up(unused):
	if accepted:
		return
	
	if player.inventory.accept(id):
		$pickup.play()
		accepted = true
		interpolate_position = position
		
func parabola(t):
	t = 2 * t - 1
	return Vector2(0, 1 - t * t) * -12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if accepted:
		position = interpolate_position * (1.0 - anim) + player.position * anim + parabola(anim)
		modulate.a = 1.0 - anim
		anim += dt * 2
		if anim > 1:
			get_parent().remove_child(self)
	var delta = position - last_position
	if delta.length_squared() < 0.0001:
		position.x = round(position.x)
		position.y = round(position.y)
	last_position = position
	
var velocity = -40
var gravity = 120
	
func _physics_process(dt):
	var ax = position.x
	
	velocity += dt * gravity
	var speed = min(velocity * dt, 8)
	
	var d = sign(speed)
	
	if abs(speed) > 0.1:
		var x = round(position.x / 4)
		var y = round(position.y / 4)
		if tilemap.get_cell(x, y + d) != -1:
			physics_map.set_cell(x, y + d, 0)
		if tilemap.get_cell(x, y + 2 * d) != -1:
			physics_map.set_cell(x, y + 2 * d, 0)
		if tilemap.get_cell(x, y + 3 * d) != -1:
			physics_map.set_cell(x, y + 3 * d, 0)
	
	move_and_collide(Vector2(0, speed))
	position.x = ax
