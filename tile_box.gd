extends Node2D

func _ready():
	var box = load("res://single_box.tscn")
	
	for x in range(-3, 4):
		for y in range(-3, 4):
			if not (x == 0 and y == 0):
				var b = box.instance()
				b.position = Vector2(x * 4, y * 4)
				add_child(b)

func update_box(node):
	for c in get_children():
		c.get_node("shape").disabled = true
	
	position = node.position
	position.x = floor(position.x / 4) * 4
	position.y = floor(position.y / 4) * 4
	
	for c in get_children():
		c.update_box()
