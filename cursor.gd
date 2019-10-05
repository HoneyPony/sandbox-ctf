extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var break_map: TileMap
var block_map: TileMap
var physics_map: TileMap

var player

var block_time = 0.1

var block_timer = 0

var item_pickup

# Called when the node enters the scene tree for the first time.
func _ready():
	break_map = get_node("/root/root/block_break_viewport/block_break_map")
	block_map = get_node("/root/root/tiles")
	physics_map = get_node("/root/root/physics_map")
	item_pickup = load("res://item_pickup.tscn")
	
	player = get_node("/root/root/player")
	pass # Replace with function body.
	
func tile_x():
	return round((position.x - 2) / 4)
	
func tile_y():
	return round((position.y - 2) / 4)
	
func break_block():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) == -1:
		return
		
	if break_map.get_cell(x, y) == -1:
		break_map.set_cell(x, y, 0)
		return
		
	if block_timer < block_time:
		return
		
	block_timer = 0
	
	var progress = break_map.get_cell_autotile_coord(x, y).x
		
	if progress == 9:
		var id = block_map.get_cell(x, y)
		
		break_map.set_cell(x, y, -1)
		block_map.set_cell(x, y, -1)
		physics_map.set_cell(x, y, -1)
		
		var pickup = item_pickup.instance()
		get_node("/root/root").add_child(pickup)
		pickup.position = Vector2(x, y) * 4 + Vector2(2, 2)
		pickup.set_id(id)
		
		return
		
	break_map.set_cell(x, y, 0, false, false, false, Vector2(progress + 1, 0))
		
	
func place_block():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
	
	var id = player.inventory.active_item().id
	if player.inventory.consume():
		block_map.set_cell(x, y, id)
		physics_map.set_cell(x, y, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x1 = tile_x()
	var y1 = tile_y()
	position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if tile_x() != x1:
			block_timer = 0
		if tile_y() != y1:
			block_timer = 0
		break_block()
	else:
		block_timer = 0
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		place_block()
		
	block_timer += delta
	
	# Uncomment for cursor display
	#position.x = tile_x() * 4 + 2
	#position.y = tile_y() * 4 + 2
