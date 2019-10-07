extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var tiles

var basic_knight
var sprite

var spawn_timer = 0

func rand(a, b):
	return round(rand_range(a, b))

func get_enemy_rate():
	if player.position.y < 15:
		return rand(8, 18)
	else:
		return rand(4, 8)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	tiles = get_node("/root/root/tiles")
	
	basic_knight = load("res://basic_knight.tscn")
	sprite = load("res://sprite.tscn")
	
func spawn(x, y):
	print("spawning at ", x, ", ", y)
	spawn_timer = get_enemy_rate()
	var instance
	if rand(0, 2) == 0:
		instance = basic_knight.instance()
	else:
		instance = sprite.instance()
	instance.position = Vector2(x, y) * 4
	get_node("/root/root").add_child(instance)
	pass
	
func try_vertical(start, end, start_y, end_y):
	var sx = int(start / 4)
	var ex = int(end / 4)
	var sy = int(start_y / 4)
	var ey = int(end_y / 4)
	
	var candidate = Vector2(0, 0)
	var has_candidate = false
	
	for x in range(sx, ex + 1):
		for y in range(sy, ey + 1):
			if tiles.get_cell(x, y) != -1:
				continue
			if tiles.get_cell(x + 1, y) != -1:
				continue
			if tiles.get_cell(x, y - 1) != -1:
				continue
			if tiles.get_cell(x + 1, y - 1) != -1:
				continue
			if tiles.get_cell(x, y - 2) != -1:
				continue
			if tiles.get_cell(x + 1, y - 2) != -1:
				continue
			if tiles.get_cell(x, y + 1) == -1:
				continue
			if tiles.get_cell(x + 1, y + 1) == -1:
				continue
				
			var test = Vector2(x, y)
			if has_candidate:
				if (test - player.position).length_squared() < (candidate - player.position).length_squared():
					candidate = test
			else:
				candidate = test
				has_candidate = true
	if has_candidate:
		spawn(candidate.x, candidate.y)
		return true
	return false

func try_horizontal(start, end, start_x, end_x):
	var sy = int(start / 4)
	var ey = int(end / 4)
	var sx = int(start_x / 4)
	var ex = int(end_x / 4)
	
	var candidate = Vector2(0, 0)
	var has_candidate = false
	
	for x in range(sx, ex + 1):
		for y in range(sy, ey + 1):
			if tiles.get_cell(x, y) != -1:
				continue
			if tiles.get_cell(x + 1, y) != -1:
				continue
			if tiles.get_cell(x, y - 1) != -1:
				continue
			if tiles.get_cell(x + 1, y - 1) != -1:
				continue
			if tiles.get_cell(x, y - 2) != -1:
				continue
			if tiles.get_cell(x + 1, y - 2) != -1:
				continue
			if tiles.get_cell(x, y + 1) == -1:
				continue
			if tiles.get_cell(x + 1, y + 1) == -1:
				continue
				
			var test = Vector2(x, y)
			if has_candidate:
				if (test - player.position).length_squared() < (candidate - player.position).length_squared():
					candidate = test
			else:
				candidate = test
				has_candidate = true
	if has_candidate:
		spawn(candidate.x, candidate.y)
		return true
	return false
				
func try_spawn():
	var bounds = get_viewport().size
	
	var left = player.position.x - bounds.x
	var right = player.position.x + bounds.x
	var top = player.position.y - bounds.y
	var bottom = player.position.y + bounds.y
	
	var out = 35
	var inner = 12
	
	if rand(0, 1) == 0:
		if try_vertical(right + inner, right + out, top, bottom):
			return true
		if try_vertical(left - out, left - inner, top, bottom):
			return true
	else:
		if try_vertical(left - out, left - inner, top, bottom):
			return true
		if try_vertical(right + inner, right + out, top, bottom):
			return true
			
	if rand(0, 1) == 0:
		if try_horizontal(bottom + inner, bottom + out, left, right):
			return true
		if try_horizontal(top - out, top - inner, left, right):
			return true
	else:
		if try_horizontal(top - out, top - inner, left, right):
			return true
		if try_horizontal(bottom + inner, bottom + out, left, right):
			return true
		
		
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 100:
		var farthest = enemies[0]
		var dist = (enemies[0].position - player.position).length_squared()
		for e in enemies:
			var new_dist = (e.position - player.position).length_squared()
			if new_dist > farthest:
				dist = new_dist
				farthest = e
		farthest.get_parent().remove_child(farthest)
	
	if spawn_timer <= 0:
		if player.position.y > 15 or player.equipped:
			try_spawn()
	else:
		spawn_timer -= delta
	pass
