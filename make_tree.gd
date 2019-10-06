extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func rand(a, b):
	return round(rand_range(a, b))
	
func plot(type, x, y):
	var f = type.instance()
	f.position = Vector2(x * 4, y * 4)
	self.add_child(f)
	
func should_wood(used, x, y, height):
	
	
	var c = Vector2(x, y)
	var dx = Vector2(1, 0)
	var dy = Vector2(0, 1)
	
	var can = false
	can = can or ((c + dy) in used)
	can = can or ((c + dy + dx) in used)
	can = can or ((c + dy - dx) in used)

	var dist = -(y + height)
	var extent = 1
	if dist > 2:
		extent = dist / 2
	if dist > 6:
		return false
		
	if x > 2:
		extent += 2
	if x < -1:
		extent += 2
	
	return can and rand(0, extent) == 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(position)
	
	var leaf = load("res://leaf.tscn")
	var wood = load("res://log.tscn")
	
	var used = []
	
	
	var width = rand(1, 2)
	var height = rand(width * 3, width * 6)
	
	
	for y in range(-height, 1):
		for x in range(0, width):
			plot(wood, x, y)
			used.append(Vector2(x, y))
		if rand(0, 3) == 0:
			plot(wood, -1, y)
		if rand(0, 3) == 0:
			plot(wood, width, y)
		
	
	var total_width = width + rand(height / 2 + 1, height + 2)
	
	var y = -height
	while width < total_width:
		width += rand(2, 4)
		for x in range(-width / 2, (width + 1) / 2):
			if should_wood(used, x, y, height):
				plot(wood, x, y)
				used.append(Vector2(x, y))
			else:
				plot(leaf, x, y)
		y -= 1
	
	for i in range(0, 3):
		width += rand(0, -1)
		for x in range(-width / 2, (width + 1) / 2):
			if should_wood(used, x, y, height):
				plot(wood, x, y)
				used.append(Vector2(x, y))
			else:
				plot(leaf, x, y)
		y -= 1
		
	while width > 0:
		width += rand(-1, -3)
		for x in range(-width / 2, (width + 1) / 2):
			if should_wood(used, x, y, height):
				plot(wood, x, y)
				used.append(Vector2(x, y))
			else:
				plot(leaf, x, y)
		y -= 1