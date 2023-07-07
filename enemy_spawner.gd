extends Node2D

var basic_knight
var sprite
var mean_sprite
var knight

func hard_territory():
	return global.player.position.x > 0 or global.player.position.y < -400
	
func very_hard_territory():
	return global.player.position.x > 100

var spawn_timer = 0

func rand(a, b):
	return round(rand_range(a, b))

func get_enemy_rate():
	if global.player.position.y < 15:
		return rand(11, 23)
	else:
		return rand(4, 8)
	

# Called when the node enters the scene tree for the first time.
func _ready():	
	basic_knight = load("res://basic_knight.tscn")
	mean_sprite = load("res://mean_sprite.tscn")
	knight = load("res://knight.tscn")
	sprite = load("res://sprite.tscn")
	
func spawn(x, y):
	print("spawning at ", x * 4, ", ", y * 4, " | player = ", global.player.position.x, ", ", global.player.position.y)
	spawn_timer = get_enemy_rate()
	var instance
	if rand(0, 2) <= 0:
		if very_hard_territory() and rand(0, 1) == 0:
			instance = knight.instance()
		elif hard_territory() and rand(0, 2) == 0:
			instance = knight.instance()
		else:
			instance = basic_knight.instance()
	else:
		if very_hard_territory() and rand(0, 1) == 0:
			instance = mean_sprite.instance()
		elif hard_territory() and rand(0, 2) == 0:
			instance = mean_sprite.instance()
		else:
			instance = sprite.instance()
	instance.position = Vector2(x, y) * 4
	global.root.add_child(instance)
	pass
	
func try_vertical(start, end, start_y, end_y):
	var sx = int(start / 4)
	var ex = int(end / 4)
	var sy = int(start_y / 4)
	var ey = int(end_y / 4)
	
	#print("vertical stripe: ", sx * 4, ", ", ex * 4, " x ", sy * 4, ", ", ey * 4)
	
	var candidate = Vector2(0, 0)
	var has_candidate = false
	var candidate_brick = false
	
	var tiles = global.tiles
	
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
			var brick = tiles.get_cell(x, y) == 8
			if has_candidate:
				if candidate_brick == brick:
					if (test - global.player.position).length_squared() < (candidate - global.player.position).length_squared():
						candidate = test
						candidate_brick = brick
				elif brick and not candidate_brick:
					if (test - global.player.position).length_squared() < (candidate - global.player.position).length_squared():
						candidate = test
						candidate_brick = brick
			else:
				candidate = test
				has_candidate = true
				candidate_brick = brick
	if has_candidate:
		spawn(candidate.x, candidate.y)
		return true
	return false

func try_horizontal(start, end, start_x, end_x):
	var sy = int(start / 4)
	var ey = int(end / 4)
	var sx = int(start_x / 4)
	var ex = int(end_x / 4)
	
	#print("horizontal stripe: ", sx * 4, ", ", ex * 4, " x ", sy * 4, ", ", ey * 4)
	
	var candidate = Vector2(0, 0)
	var has_candidate = false
	
	var tiles = global.tiles
	
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
				if (test - global.player.position).length_squared() < (candidate - global.player.position).length_squared():
					candidate = test
			else:
				candidate = test
				has_candidate = true
	if has_candidate:
		spawn(candidate.x, candidate.y)
		return true
	return false
				
func try_spawn():
	var bounds = get_viewport().size / 3.0
	
	var player = global.player
	
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
		var dist = (enemies[0].position - global.player.position).length_squared()
		for e in enemies:
			var new_dist = (e.position - global.player.position).length_squared()
			if new_dist > dist:
				dist = new_dist
				farthest = e
		farthest.get_parent().remove_child(farthest)
	
	if spawn_timer <= 0:
		if global.player.equipped:
			try_spawn()
	else:
		spawn_timer -= delta
	pass
